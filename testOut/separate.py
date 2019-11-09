import os
from shutil import copyfile

def main():
  l = 0;
  r = 0;
  
  for root, dirs, files in os.walk("testOut", topdown=False):
    for name in files:
      print(os.path.join(root, name))
      if ('0' in name):
        copyfile(os.path.join(root, name), "left\\img_" +  str(l) + ".png")
        #os.rename("left\\" + name, "left\\img_" +  i + ".png")
        l = l + 1
      elif ('1' in name):
        copyfile(os.path.join(root, name), "right\\img_" +  str(r) + ".png")
        #os.rename("right\\" + name, "right\\img_" +  i + ".png")
        r = r + 1
main()