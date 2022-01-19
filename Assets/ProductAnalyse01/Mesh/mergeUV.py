import os
import numpy as np

objOriginFolder = "d:\TA_Training_Homework\Assets\ProductAnalyse01\Mesh\OriginalData\SH11"
objSaveFolder = "d:\TA_Training_Homework\Assets\ProductAnalyse01\Mesh\SH11"

def getFilePath(name):
    return objOriginFolder + '\\' + name

def fixObj(objname):
    vertex = []
    normal = []
    uvs = []
    face = []
    other = []

    objSavePath = objSaveFolder + '\\' + objname + ".obj"
    ojbFilePath = getFilePath(objname + ".obj")
    csvFilePath = getFilePath(objname + ".csv")

    if not os.path.exists(csvFilePath):
        print("Can't find {0}.csv".format(objname))
        return

    data = np.loadtxt(csvFilePath, dtype=np.str_, delimiter=',')
    data = data[1:].tolist()
    count = 0
    uvInfo = ''
    for d in data:
        if count % 2 == 0:
            uvInfo = "vt " + d[1]
        else:
            uvInfo = uvInfo + " " + d[1] + "\n"
            uvs.append(uvInfo)
        count = count + 1


    with open(ojbFilePath) as file:
        while 1:
            line = file.readline()
            if not line:
                break
            strs = line.split(" ")
            if strs[0] == 'v':
                vertex.append(line)
            elif strs[0] == 'vt':
                uvs.append(line)
            elif strs[0] == 'vn':
                normal.append(line)
            elif strs[0] == 'f':
                face.append(line)
            else:
                other.append(line)

    with open(objSavePath, "w") as file:
        for v in vertex:
            file.write(v)
        for a in uvs:
            file.write(a)
        for n in normal:
            file.write(n)
        for ot in other:
            file.write(ot)
        for f in face:
            ff = f.split(" ")
            ff0 = ff[1].split("/")[0]
            ff1 = ff[2].split("/")[0]
            ff2 = ff[3].split("/")[0]
            file.write("f {0}/{0}/{0} {1}/{1}/{1} {2}/{2}/{2}\n".format(ff0, ff1, ff2))

    print(objname + ".obj Finished!")

if __name__ == "__main__":
    files = os.listdir(objOriginFolder)
    for file in files:
        if file[-3:] == "obj":
            fixObj(file[:-4])