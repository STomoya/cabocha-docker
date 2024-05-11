from __future__ import annotations

import subprocess


class InvalidArgsError(Exception):
    pass


def _subprocess_run(
    software: str, text: str, *, dictionary: str = 'ipadic', args: list[str] | str | None = None
) -> str:
    if args is None:
        args = []
    elif isinstance(args, str):
        args = args.split(' ')

    if '-d' in args or '--dicdir' in args:
        raise InvalidArgsError('Passing dictionary directory is not supported. Use `dictionary` argument.')
    if dictionary == 'neologd':
        args += ['-d', '/usr/local/lib/mecab/dic/mecab-ipadic-neologd/']

    cmd = f'echo {text} | {software} ' + ' '.join(args)
    cmd = cmd.strip()

    response = subprocess.check_output(
        cmd,
        shell=True,
        text=True,
    )
    return cmd, response.strip('\n')


def run_mecab(text: str, *, dictionary: str = 'ipadic', args: list[str] | str | None = None) -> str:
    return _subprocess_run(software='mecab', text=text, dictionary=dictionary, args=args)


def run_cabocha(text: str, *, dictionary: str = 'ipadic', args: list[str] | str | None = None) -> str:
    return _subprocess_run(software='cabocha', text=text, dictionary=dictionary, args=args)
