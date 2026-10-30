#!/usr/bin/env python3
"""Прогоняет ВСЕ тесты файла тренажёра через ghci.

    python3 check.py trainers/01_digits.hs
    python3 check.py trainers/*.hs

Тест — это строка вида   -- main = print (EXPR)  -- EXPECTED
EXPECTED вида "error: MSG" значит, что EXPR должен упасть с  error "MSG".
"""
import subprocess, sys

def hs(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'

def tests_of(path):
    out = []
    for n, line in enumerate(open(path, encoding='utf-8'), 1):
        if line.startswith('-- main = print '):
            body = line[len('-- main = print '):].rstrip('\n')
            i = body.rfind('  -- ')
            if i >= 0:
                out.append((n, body[:i].strip(), body[i + 5:].strip()))
    return out

def script_for(tests):
    s = ['import qualified Control.Exception as E']
    for n, e, x in tests:
        # undefined -> TODO, другое исключение -> FAIL
        on_exc = (f'(\\ex -> let m = show (ex :: E.SomeException) in putStrLn '
                  f'(if take 17 m == "Prelude.undefined" then "TODO {n}" else "FAIL {n} упало: " ++ head (lines m ++ [""]) ++ "   ждали: " ++ {hs(x)}))')
        if x.startswith('error: '):
            s.append(f'E.catch (E.evaluate (length (show ({e}))) >> putStrLn "FAIL {n} нет ошибки, ждали: {x[7:]}") '
                     f'(\\(E.ErrorCall m) -> putStrLn (if m == {hs(x[7:])} then "ok" else if m == "Prelude.undefined" then "TODO {n}" else "FAIL {n} другая ошибка: " ++ m))')
        else:
            s.append(f'E.catch (let r = show ({e}) in E.evaluate (length r) >> putStrLn '
                     f'(if r == {hs(x)} then "ok" else "FAIL {n} получили: " ++ r ++ "   ждали: " ++ {hs(x)})) {on_exc}')
    return '\n'.join(s) + '\n'

def run(path):
    tests = tests_of(path)
    p = subprocess.run(['ghci', '-v0', '-w', path], input=script_for(tests),
                       capture_output=True, text=True, timeout=300)
    out = p.stdout.splitlines()
    ok = out.count('ok')
    todo = [l.split()[1] for l in out if l.startswith('TODO')]
    fails = [l for l in out if l.startswith('FAIL')]
    print(f'{path}: {ok}/{len(tests)} ok, не решено: {len(todo)}, ошибок: {len(fails)}')
    for l in fails:
        _, n, rest = l.split(' ', 2)
        print(f'   строка {n}: {rest}')
    if p.stderr.strip():
        print(p.stderr.strip()[:3000])

for f in sys.argv[1:]:
    run(f)
