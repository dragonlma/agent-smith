import os,sys,subprocess,time,traceback

THIS = os.path.basename(__file__)
DIRPATH = sys.argv[1]
BASEPATH = sys.argv[2]
TENANT = "agent-smith"

if not os.path.exists(BASEPATH):
    BASEPATH="http://localhost:8080/"

if not os.path.exists(DIRPATH):
    print "Error: missing path parameter\nUsage: python %s <dir-to-watch> [path-to-cms]\n" % THIS
    sys.exit(1)

print "THIS:%s, DIRPATH:%s, BASEPATH:%s, TENANT:%s" % (THIS, DIRPATH, BASEPATH,TENANT)

FILES_TO_MONITOR = ["top.sh.out", "netstat.sh.out", "dmesg.sh.out"]
FILE_TO_MONITOR_MTIME = [ 0 , 0 , 0]

POLL_INTERVAL_SECONDS = 3

while True:
    try:
        for i in range(len(FILES_TO_MONITOR)):
            fileName = FILES_TO_MONITOR[i]
            FILECHANGE = DIRPATH + "/" + fileName
            fileStat = os.stat(FILECHANGE)
            mtime = fileStat.st_mtime
            if FILE_TO_MONITOR_MTIME[i] == mtime :
                continue
            else :
                FILE_TO_MONITOR_MTIME[i] = mtime

            print "Publishing file:[",FILECHANGE,"], - tenant:[",TENANT,"], - channel:[",FILECHANGE,"], file[",fileName,"], mtime[",mtime,"]"
            URL = BASEPATH+"pubsub?tenant="+TENANT+"&channel="+fileName
            command = "curl -s -S -m 1 -X POST \"%s\" --data \"`cat %s`\" > /dev/null" % (URL, FILECHANGE)
            print command
            subprocess.call(command, shell=True)
        time.sleep(POLL_INTERVAL_SECONDS)
    except:
        print "Exception in user code:"
        traceback.print_exc(file=sys.stdout)

