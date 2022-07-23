import hashlib
import pathlib
import argparse

def listToString(s):
   
    # initialize an empty string
    str1 = " "
   
    # return string 
    return (str1.join(s))

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('-filename','-f', type=str,nargs='+',
                    help='an integer for the accumulator')
    
args = parser.parse_args()
if args.filename:
    Filaname=listToString(args.filename)

    file = pathlib.Path(__file__).resolve().parent
    filenya = file.joinpath("binutils-" + Filaname + ".tar.xz")
    file_hash = hashlib.sha512()
    with filenya.open("rb") as f:
        while True:
            data = f.read(131072)
            if not data:
                break
            file_hash.update(data)

    filenya = file.joinpath("binutils-" + Filaname + ".sha512")
    with filenya.open('w') as f:
        f.write(file_hash.hexdigest())