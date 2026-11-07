import sys; sys.path.insert(0,'/home/claude/diploma-boy/robots/copyright'); sys.path.insert(0,'.')
import ngram, content_889 as C
ref,_=ngram.load_fingerprint_files()
texts=[]
def walk(x):
    if isinstance(x,str): texts.append(x)
    elif isinstance(x,(list,tuple)): [walk(y) for y in x]
    elif isinstance(x,dict): [walk(v) for k,v in x.items() if k!='fig' and k!='color' and k!='icon']
for n in ('NOTES','TEACH','HINGLISH','BOOK','SOLVED','PRACTICE','EQUATIONS','MISTAKES','REVISION'): walk(getattr(C,n))
def det(text):
    w=ngram.words(text);h=[ngram.fp(tuple(w[k:k+3])) in ref for k in range(len(w)-2)];out=[];k=0;best=0
    while k<len(h):
        if h[k]:
            j=k
            while j<len(h) and h[j]: j+=1
            best=max(best,j-k+2)
            if j-k+2>=8: out.append(' '.join(w[k:j+2]))
            k=j
        else: k+=1
    return out,best
res=[(det(x),x[:50]) for x in texts]
print('max run',max(r[0][1] for r in res)); print('overlap',round(ngram.score(' '.join(texts),ref)[0],4))
for (o,b),x in res:
    if o: print('>>',o)
