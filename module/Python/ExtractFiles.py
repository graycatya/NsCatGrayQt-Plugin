import string
import sys
import os

class ExtractFile:
    Packagedirectory = ""
    NsisScript = ""

    def __init__(self, packdir, nsisscript) -> None:
        self.Packagedirectory = packdir
        self.NsisScript = nsisscript
        pass

    def Build() -> None:
        pass

if __name__ == '__main__':
    print("quit")