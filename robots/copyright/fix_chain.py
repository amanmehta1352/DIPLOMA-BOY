"""Build a trust bundle for a host that sends an incomplete certificate chain. TLS verification stays ON.

   python3 robots/copyright/fix_chain.py ncert.nic.in /tmp/bundle.pem

Reads the server's certificate (only to find the 'CA Issuers' address written in it), downloads that issuer certificate,
and writes certifi's roots + the issuer to the bundle. The download is then verified normally against a root in certifi:
if the issuer does not chain to a trusted root, verification still fails.
"""
import ssl, sys, urllib.request
import certifi
from cryptography import x509
from cryptography.x509.oid import AuthorityInformationAccessOID, ExtensionOID
from cryptography.hazmat.primitives.serialization import Encoding

host, out = sys.argv[1], sys.argv[2]
leaf = x509.load_pem_x509_certificate(ssl.get_server_certificate((host, 443), timeout=60).encode())
aia = leaf.extensions.get_extension_for_oid(ExtensionOID.AUTHORITY_INFORMATION_ACCESS).value
urls = [d.access_location.value for d in aia if d.access_method == AuthorityInformationAccessOID.CA_ISSUERS]
print('issuer address:', urls[:1] or 'none')
bundle = open(certifi.where(), 'rb').read()
for u in urls[:1]:
    data = urllib.request.urlopen(u, timeout=60).read()
    try: cert = x509.load_der_x509_certificate(data)
    except ValueError: cert = x509.load_pem_x509_certificate(data)
    print('issuer:', cert.subject.rfc4514_string())
    bundle += b'\n' + cert.public_bytes(Encoding.PEM)
open(out, 'wb').write(bundle)
ctx = ssl.create_default_context(cafile=out)       # proof: a verified connection now works
with ctx.wrap_socket(__import__('socket').create_connection((host, 443), timeout=60), server_hostname=host):
    print('verified TLS to', host, 'OK')
