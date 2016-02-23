import sys
import subprocess

print("D FRIENDLY LINKER INVOKED")

linker = "ldc2"

filteredCppLibrary = filter(lambda k: len(k) >= 2 and  k[:2] == "-l", sys.argv)
filteredObjectFiles = filter(lambda k: len(k) >= 2 and  k[-2:len(k)] == ".o", sys.argv)

passthroughLibraries = []
for iterationCppLibrary in filteredCppLibrary:
	passthroughLibraries.append("-L" + iterationCppLibrary)

parameterList = filteredObjectFiles + passthroughLibraries

subprocess.call([linker] + parameterList + ["-of=PtrEngine"])