import os
import shutil
from PIL import Image
tbl=[72,48,32,96,144,192];
fileTbl=["hdpi","ldpi","mdpi","xhdpi","xxhdpi","xxxhdpi"];
index = 0;
for size in tbl:
	finalFlod=("drawable-%s/" % fileTbl[index]);
	index = index + 1;
	flod = ("icon/%d/icon.png" % size  );
	shutil.copy( flod, finalFlod  );
	


