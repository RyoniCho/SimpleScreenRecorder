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
        self.resizeMode=False

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
      
        #print(res.stdout.decode('utf-8'))
    
    def ResizeFileToMp4(self,videoFileName):
        outputPath=os.path.join(os.path.dirname(videoFileName),"Output")
        print(outputPath)
        if not os.path.exists(outputPath):
            print(f"not exist:{outputPath}")
            os.makedirs(outputPath)
        
        fileName=os.path.basename(videoFileName)
        outputPath=os.path.join(outputPath,fileName.replace(".mov","_modified.mp4"))

      

        resizeCommand=f'ffmpeg -i "{videoFileName}" -q:v 0 "{outputPath}"'
        print(f"Resize Mov VideoFile to Mp4 : {resizeCommand}")
        res = subprocess.run(resizeCommand,shell=True,capture_output=True)
      
        #print(res.stdout.decode('utf-8'))

       

    def Run(self):
        if self.IsDirMode:
            if os.path.isdir(self.targetPath):
                fileList=list()
                fileList=glob.glob(os.path.join(self.targetPath,"*.mov"))
                fileList.append(glob.glob(os.path.join(self.targetPath,"*.mp4")))
                if len(fileList) == 0:
                    print(f"There is no Mp4 or Mov files in {self.targetPath}")
                    sys.exit(-1)
                else:
                    print(f"{len(fileList)} files Detected. Process Start.")
                    for f in fileList:
                        print(f"File: {f}")
                        if self.resizeMode==False:
                            self.DetachAudioFromVideoFile(f)
                            self.MergeVideoAndAudioFile(f)
                        else:
                            self.ResizeFileToMp4(f)
                    print("Finished")
            else:
                print(f"Error: {self.targetPath} is not Directory!! ")
                sys.exit(-1)

           
           
        else:
            print(f"File: {self.targetPath}")
            if self.resizeMode==False:
                self.DetachAudioFromVideoFile(self.targetPath)
                self.MergeVideoAndAudioFile(self.targetPath)
            else:
                self.ResizeFileToMp4(self.targetPath)
            print("Finished")


    def SetArgs(self):
        parser = argparse.ArgumentParser(description='Fix AudioChannel For SimpleScreenRecorder')
    
        parser.add_argument('-d','--d', type=str, 
                        help='Target Directory Path including Video Files')
        parser.add_argument('-f','--f',type=str, 
                        help='Target File Path')
        parser.add_argument('-r','--r', type=str,
                        help='Resize File')

        args = parser.parse_args()

        if(args.d is not None and args.f is not None):
            print("Error: cannot use both option -f and -d at the same time")
            sys.exit(-1)
        if(args.d is None and args.f is None):
            print("Error: Need Option -f or -d")
            parser.print_help()
            sys.exit(-1)
        else:
            if(args.r is not None):
                self.resizeMode=True
            if(args.d is not None):
                self.IsDirMode=True
                self.targetPath=args.d
            if(args.f is not None):
                self.IsDirMode=False
                self.targetPath=args.f






if __name__=="__main__":

    fixAudioChannel=FixAudioChannel()
    fixAudioChannel.Run()