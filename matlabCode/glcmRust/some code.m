>> imtool
>> imtool('board.tif')
>> histeq('board.tif')
??? Error using ==> iptcheckinput
Function HISTEQ expected its first input, I,
to be one of these types:

  uint8, uint16, double, int16, single

Instead its type was char.

Error in ==> histeq at 71
   iptcheckinput(a,{'uint8','uint16','double','int16','single'}, ...
 
>> I=imread('board.tif');
>> histeq(I)
??? Error using ==> iptcheckinput
Function HISTEQ expected its first input, I, to be two-dimensional.

Error in ==> histeq at 71
   iptcheckinput(a,{'uint8','uint16','double','int16','single'}, ...
 
>> histeq(I(:,:,1))
Warning: Image is too big to fit on screen; displaying at 67% 
> In imuitools\private\initSize at 73
  In imshow at 262
  In histeq at 146
>> imtool(I(:,:,1))
>> I=imread('rust100mm.jpg');
>> imtool(I(:,:,1))
>> imtool(I(:,:,2))
>> I2=stretchlim(I);
>> I2=imadjust(I,stretchlim(I),[]);
>> imshow(I2)
>> imshow(I2)
>> J=imread('timber100mm');
??? Error using ==> imread at 361
File "timber100mm" does not exist.
 
>> J=imread('timber100mm.jpg');
>> imshow(J)
>> close all
>> imshow(J)
>> imtool(J(:,:,2))
>> J2=imadjust(J,stretchlim(J),[]);
>> imshwo(J2)
??? Undefined function or method 'imshwo' for input arguments of type 'uint8'.
 
>> imshow(J2)
>> close all
>> imshow(J2)
>> figure;imshow(I2)
>> 