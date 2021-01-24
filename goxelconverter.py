
import math
import pprint


filename = "./goxel.txt"
filename2 = "./converted.txt"
# Berechnet die Distanz zwischen 2 Punkten
def distance(a, b):
    if (a == b):
        return 0
    elif (a < 0) and (b < 0) or (a > 0) and (b > 0):
        if (a < b):
            return (abs(abs(a) - abs(b)))
        else:
            return -(abs(abs(a) - abs(b)))
    else:
        return math.copysign((abs(a) + abs(b)),b)


# gibe die Koordinaten der Goxeldatei zurück
def getCoordsGoxel(file):
    goxelfile = open(file, "r")
    # Splittet die Goxel-file in listen
    goxel_matrix = []
    i = 0
    for line in goxelfile:
        i = i + 1
        if i > 3:
            goxel_matrix.append((line.split(" ")))
    goxelfile.close()
    return goxel_matrix


# Gibe die Länge der zu erschaffenden Matrix zurück
def getMatrixlen(file):
    x_list = []
    y_list = []
    z_list = []
    for element in getCoordsGoxel(file):
        x_list.append(int(element[0]))
        y_list.append(int(element[1]))
        z_list.append(int(element[2]))
    x_list.sort()
    y_list.sort()
    z_list.sort()
    x_start = x_list[0]
    x_end =(x_list[len(x_list) - 1])
    y_start = y_list[0]
    y_end =(y_list[len(y_list) - 1])
    z_start = z_list[0]
    z_end =(z_list[len(z_list) - 1])
    x = (int(distance(int(x_start), int(x_end))))
    y = (int(distance(int(y_start), int(y_end))))
    z = (int(distance(int(z_start), int(z_end))))
    return [x,y,z]

def getSmallestValues(file):
    x_list = []
    y_list = []
    z_list = []
    for element in getCoordsGoxel(file):
        x_list.append(int(element[0]))
        y_list.append(int(element[1]))
        z_list.append(int(element[2]))
    x_list.sort()
    y_list.sort()
    z_list.sort()
    x_start = x_list[0]
    y_start = y_list[0]
    z_start = z_list[0]
    if x_start < 0:
        x_start = x_start * (-1)
    if y_start < 0:
        y_start = y_start * (-1)
    if z_start < 0:
        z_start = z_start * (-1)
    return [x_start, y_start, z_start]

def setNewEmptyVoxelMatrix(matrix_size):
    a_3d_list = []
    # * Z wird zur 3-Dimensionaler Ebene
    for i in range(matrix_size[2] +1):
        a_3d_list.append([])
        # Hier ist X * Y 2D Ebene
        for j in range(matrix_size[1] +1):
            a_3d_list[i].append([])
            for k in range(matrix_size[0] +1):
                a_3d_list[i][j].append(0)
    return a_3d_list

# Macht aus den Minuskoordinaten eine positive Matrix
def setPositiveCoordinates(file, xyz_list):
    manipulated_coords = []
    for element in getCoordsGoxel(file):
        element[0] = int(element[0]) + int(xyz_list[0])
        element[1] = int(element[1]) + int(xyz_list[1])
        element[2] = int(element[2]) + int(xyz_list[2])
        manipulated_coords.append(element)
    return manipulated_coords
        

def getNewVoxelInMatrix(newcoords, a_3d_list):
    for voxel in (newcoords):
        a_3d_list[voxel[2]][voxel[1]][voxel[0]] = 1
    return (a_3d_list)

def writeNewMinecraftFile(filename, new_matrix, matrix_size):
    new_goxelfile = open(filename, "w")
    for full_element in new_matrix:
        for el_list in full_element:
            for number in el_list:
                new_goxelfile.write(str(number) + " ")
            new_goxelfile.write("\n")
        new_goxelfile.write("\n")
    new_goxelfile.close()

# Größe der Matrix X, Y, Z
matrix_size = (getMatrixlen(filename))

# fertige Leere Matrix
a_3d_list = setNewEmptyVoxelMatrix(matrix_size)

# Werte im Minusbereich
small_values = getSmallestValues(filename)

# Matrixgröße
newcoords = setPositiveCoordinates(filename, small_values)

# Liste mit den Blöcken die in Minecraft gefüllt werden
new_matrix = getNewVoxelInMatrix(newcoords, a_3d_list)

# Schreibt neue Datei
writeNewMinecraftFile(filename2, new_matrix, matrix_size)


