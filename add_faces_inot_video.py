# coding=utf-8
import numpy as np
import matplotlib.pyplot as plt
import pywt, sys
import pywt.data
import math
import os
import cv2
import logging
import time
from PIL import Image
# import script.util as imutil
import imutils as imutil


reader = cv2.VideoCapture("C:/Users/Vijay kumar yadav/Downloads/models/facedetect_debate_noaudio.mkv")
size = (int(reader.get(3)), int(reader.get(4)))
fourcc = cv2.VideoWriter_fourcc(*'XVID')
writer = cv2.VideoWriter('facedetect_debate_noaudio_output.mp4', fourcc, 30, size)
print('is opened:', reader.isOpened())
print('is opened:', writer.isOpened())

num = 0
numFrameToProcess = 1000
imagelist = dict()
for d in ['C:/Users/Vijay kumar yadav/Downloads/faces94/faces94/female'] :
    print ('looking', d)
    l_d = [os.path.join(d, o) for o in os.listdir(d) if os.path.isdir(os.path.join(d, o))]
    for ld_i in l_d:
        numimg = 0
        for im in os.listdir(ld_i):
            p = str(ld_i).replace('\\','/') + '/' + im
            print(p)
            #imm = cv2.imread(p)
            imagelist[ld_i.split('\\')[1] + '_' + im] = p
            #cv2.imshow(p,imm);cv2.waitKey(1)
            #if numimg ++ > 10:  break

facecnter = 0
while True:
    ret, img = reader.read()
    if ret == False:  break

    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img_pil = Image.fromarray(img)

    print('adding face',facecnter ,' to image',num)
    if (facecnter >= len(list(imagelist.items()))) :
        print('no more faces')
        break
    with Image.open(list(imagelist.items())[facecnter][1]) as face:
        #face.rotate(90)
        img_pil.paste(face,(20,20))
        img = np.asarray(img_pil)
        img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
        t = list(imagelist.items())[facecnter][0]
        img = cv2.putText(img,"orig:"+t,(10,10),cv2.FONT_HERSHEY_TRIPLEX,0.5,(255, 0, 0),1)
    writer.write(img)
    key = cv2.waitKey(1)

    if num == numFrameToProcess: break
    if key == ord('q'):
        break
    facecnter = facecnter + 1
    num       = num + 1
writer.release()
reader.release()
cv2.destroyAllWindows()
time.sleep(1)