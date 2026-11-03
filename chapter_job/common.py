"""Shared by job.py, providers.py and tools. Kept separate so that running job.py as a script
(module __main__) and importing it elsewhere use the SAME exception classes."""
import json, re


class ProviderUnavailable(Exception):
    """A provider could not give an answer right now or at all. Policy: the job ends 'blocked', never 'failed'.
    kind: transient (5xx after retries) | timeout | quota (429) | permanent (auth / model gone) | not_free | not_configured | time_budget"""
    def __init__(self, provider, kind, detail=''):
        self.provider, self.kind, self.detail = provider, kind, detail
        super().__init__(f'{provider}: {kind}' + (f' ({detail})' if detail else ''))


class ProviderRequestError(Exception):
    """The provider rejected OUR request as malformed (HTTP 400/422) or sent an unreadable envelope: a code/schema bug -> 'failed'."""


def parse_json(txt):
    txt = re.sub(r'^```(?:json)?\s*|\s*```$', '', (txt or '').strip())
    i, j = txt.find('{'), txt.rfind('}')
    if i < 0 or j < i: raise ValueError('no JSON object in the reply')
    return json.loads(txt[i:j + 1], strict=False)   # models often put raw newlines/tabs inside strings


def text_of(d, keys=('concepts', 'formulas', 'examples', 'mcqs')):
    out = []
    for k in keys:
        for x in d.get(k) or []:
            if isinstance(x, dict):
                out += [str(x.get(f, '')) for f in ('title', 'body', 'question', 'explanation')] + [str(o) for o in x.get('options') or []]
    return ' '.join(out)
