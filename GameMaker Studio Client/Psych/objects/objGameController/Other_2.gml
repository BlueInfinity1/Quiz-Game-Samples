/// @description Insert description here
// You can write your code in this editor

//creationTime = scrGetEpochTime()

globalvar greenColor, defaultTextColor, buttonDarkGreen, buttonDarkGrey, lightGreen, darkGreen, lightRed, darkRed, lightBlue,
darkBlue, bgColor;

bgColor = make_color_rgb(12,0,48)

greenColor = make_color_rgb(83,214,74)
defaultTextColor = c_white //make_color_rgb(135,102,60)
buttonDarkGreen = make_color_rgb(62,147,55)
buttonDarkGrey = make_color_rgb(101,101,101)
lightGreen = make_color_rgb(76,227,109)
darkGreen = make_color_rgb(46,139,67)
lightBlue = make_color_rgb(15,203,253)
darkBlue = make_color_rgb(7,100,125)
lightRed = make_color_rgb(235,52,91)
darkRed = make_color_rgb(136,30,53)

globalvar totalDomainCount, num, divider, deduction, decryptedStringLengthPerArrayPosition,encryptedArray, encryptedSecondLetter, encryptedSeventhLetter,
encryptedNineteenthLetter, currentUrl, currentUrlLength;

totalDomainCount = 2

deduction = 2
divider = 3
decryptedStringLengthPerArrayPosition = 1

currentUrlLength[0] = 56*0.25
encryptedArray[0, 0] = 176
encryptedArray[1, 0] = 299
encryptedArray[2, 0] = 215
encryptedArray[3, 0] = 335
encryptedArray[4, 0] = 353
encryptedArray[5, 0] = 302
encryptedArray[6, 0] = 308
encryptedArray[7, 0] = 286
encryptedArray[8, 0] = 335
encryptedArray[9, 0] = 332
encryptedArray[10, 0] = 350
encryptedArray[11, 0] = 140
encryptedArray[12, 0] = 332
encryptedArray[13, 0] = 305
encryptedArray[14, 0] = 350
encryptedArray[15, 0] = 334
encryptedArray[16, 0] = 157
encryptedArray[17, 0] = 185
encryptedArray[18, 0] = 206
encryptedArray[19, 0] = 220
encryptedArray[20, 0] = 303
encryptedArray[21, 0] = 222
encryptedArray[22, 0] = 184
encryptedArray[23, 0] = 274
encryptedArray[24, 0] = 156
encryptedSecondLetter[0] = 326
encryptedSeventhLetter[0] = 344
encryptedNineteenthLetter[0] = 168

currentUrlLength[1] = 72*0.25
encryptedArray[0, 1] = 208
encryptedArray[1, 1] = 317
encryptedArray[2, 1] = 335
encryptedArray[3, 1] = 308
encryptedArray[4, 1] = 317
encryptedArray[5, 1] = 332
encryptedArray[6, 1] = 317
encryptedArray[7, 1] = 134
encryptedArray[8, 1] = 365
encryptedArray[9, 1] = 329
encryptedArray[10, 1] = 293
encryptedArray[11, 1] = 323
encryptedArray[12, 1] = 305
encryptedArray[13, 1] = 344
encryptedArray[14, 1] = 347
encryptedArray[15, 1] = 140
encryptedArray[16, 1] = 299
encryptedArray[17, 1] = 335
encryptedArray[18, 1] = 329
encryptedArray[19, 1] = 307
encryptedArray[20, 1] = 299
encryptedArray[21, 1] = 144
encryptedArray[22, 1] = 256
encryptedArray[23, 1] = 146
encryptedArray[24, 1] = 183
encryptedSecondLetter[1] = 332
encryptedSeventhLetter[1] = 350
encryptedNineteenthLetter[1] = 266

scrCheckDomain()