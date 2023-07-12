import subprocess
import glob
import shutil
import argparse
import sys
import os



class FixAudioChannel():

    def __init__(self) -> None:
        self.SetArgs()
        self.IsDirMode=False
        self.targetPath=''
      

        self.SetArgs()

      


    def DetachAudioFromVideoFile(self,videoFileName):
        outputPath=videoFileName.replace(".mp4","_audioOutput.mp3")

        detachCommand=f'ffmpeg -i "{videoFileName}" -vn -acodec libmp3lame -ar 44.1k -ac 2 -ab 128k "{outputPath}"'
        print(f"Detach Audio From Video File: {detachCommand}")
        res = subprocess.run(detachCommand,shell=True,capture_output=True)
       
        #print(res.stdout.decode('utf-8'))


        
    def MergeVideoAndAudioFile(self,videoFileName):

        outputPath=os.path.join(os.path.dirname(videoFileName),"Output")
        print(outputPath)
        if not os.path.exists(outputPath):
            print(f"not exist:{outputPath}")
            os.makedirs(outputPath)
        
        fileName=os.path.basename(videoFileName)
        outputPath=os.path.join(outputPath,fileName.replace(".mp4","_modified.mp4"))

        audioFilePath=videoFileName.replace(".mp4","_audioOutput.mp3")

        mergeCommand=f'ffmpeg -i "{videoFileName}" -i "{audioFilePath}" -c copy "{outputPath}"'
        print(f"MERGE Video and Audio : {mergeCommand}")
        res = subprocess.run(mergeCommand,shell=True,capture_output=True)

        return outputPath
      
        #print(res.stdout.decode('utf-8'))

    def EncodeVideoToHEVCFile(self,videoFilePath):

        encodeOutputPath=os.path.join(os.path.dirname(videoFilePath),"EncodedOutput")
        if not os.path.exists(encodeOutputPath):
            print(f"not exist: {encodeOutputPath} create directory")
            os.makedirs(encodeOutputPath)
            
        
        outPutFilePath=os.path.join(encodeOutputPath,os.path.basename(videoFilePath).replace("_modified","_encoded"))

        EncodeCommand= f'avconvert --source "{videoFilePath}" --preset PresetHEVC1920x1080 --output "{outPutFilePath}"'
        print(f"Encode Video.. : {EncodeCommand}")
        res = subprocess.run(EncodeCommand,shell=True,capture_output=True)
        print(res.stdout.decode('utf-8'))

        return outPutFilePath

        
    
    def ResizeFileToMp4(self,videoFileName):
        outputPath=os.path.join(os.path.dirname(videoFileName),"ResizeOutput")
        print(outputPath)
        if not os.path.exists(outputPath):
            print(f"not exist:{outputPath}")
            os.makedirs(outputPath)
        
        fileName=os.path.basename(videoFileName)
        outputPath=os.path.join(outputPath,fileName)

      

        resizeCommand=f'ffmpeg -i "{videoFileName}" -q:v 0 "{outputPath}"'
        print(f"Resize VideoFile : {resizeCommand}")
        res = subprocess.run(resizeCommand,shell=True,capture_output=True)
      
        #print(res.stdout.decode('utf-8'))

       

    def Run(self):
        if self.IsDirMode:
            if os.path.isdir(self.targetPath):
                fileList=list()
                fileList=glob.glob(os.path.join(self.targetPath,"*.mov"))
                fileList.extend(glob.glob(os.path.join(self.targetPath,"*.mp4")))
                if len(fileList) == 0:
                    print(f"There is no Mp4 or Mov files in {self.targetPath}")
                    sys.exit(-1)
                else:
                    print(f"{len(fileList)} files Detected. Process Start.")
                    for f in fileList:
                        print(f"File: {f}")
                        
                        self.DetachAudioFromVideoFile(f)
                        output=self.MergeVideoAndAudioFile(f)
                        output=self.EncodeVideoToHEVCFile(output)
                        self.ResizeFileToMp4(output)

                        
                            
                    print("Finished")
            else:
                print(f"Error: {self.targetPath} is not Directory!! ")
                sys.exit(-1)

           
           
        else:
            print(f"File: {self.targetPath}")
         
            self.DetachAudioFromVideoFile(self.targetPath)
            output=self.MergeVideoAndAudioFile(self.targetPath)
            output=self.EncodeVideoToHEVCFile(output)
            self.ResizeFileToMp4(output)
           
                
            print("Finished")


    def SetArgs(self):
        parser = argparse.ArgumentParser(description='Fix AudioChannel For SimpleScreenRecorder')
    
        parser.add_argument('-d','--d', type=str, 
                        help='Target Directory Path including Video Files')
        parser.add_argument('-f','--f',type=str, 
                        help='Target File Path')
        
        args = parser.parse_args()

        if(args.d is not None and args.f is not None):
            print("Error: cannot use both option -f and -d at the same time")
            sys.exit(-1)
        if(args.d is None and args.f is None):
            print("Error: Need Option -f or -d")
            parser.print_help()
            sys.exit(-1)
        else:
          
            if(args.d is not None):
                self.IsDirMode=True
                self.targetPath=args.d
            if(args.f is not None):
                self.IsDirMode=False
                self.targetPath=args.f






if __name__=="__main__":

    fixAudioChannel=FixAudioChannel()
    fixAudioChannel.Run()