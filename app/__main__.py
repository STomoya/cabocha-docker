from fastapi import FastAPI

from app.core import InvalidArgsError, run_cabocha, run_mecab

app = FastAPI()


@app.get('/')
def read_root():
    return {'Hello': 'World'}


@app.get('/mecab')
def get_mecab(text: str, dictionary: str = 'ipadic', args: str | None = None):
    try:
        cmd, response = run_mecab(text=text, dictionary=dictionary, args=args)
        success = True
    except InvalidArgsError:
        cmd = response = ''
        success = False

    return {'result': response, 'success': success, 'cmd': cmd}


@app.get('/cabocha')
def get_cabocha(text: str, dictionary: str = 'ipadic', args: str | None = None):
    try:
        cmd, response = run_cabocha(text, dictionary=dictionary, args=args)
        success = True
    except InvalidArgsError:
        cmd = response = ''
        success = False

    return {'result': response, 'success': success, 'cmd': cmd}
