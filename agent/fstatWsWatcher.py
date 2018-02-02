import os,sys,subprocess,time,threading,traceback
import websocket

THIS = os.path.basename(__file__)
DIRPATH = sys.argv[1]
BASEPATH = sys.argv[2]
TENANT = "agent-smith"

if not os.path.exists(BASEPATH):
    BASEPATH="ws://127.0.0.1:9001"

if not os.path.exists(DIRPATH):
    print "Error: missing path parameter\nUsage: python %s <dir-to-watch> [path-to-cms]\n" % THIS
    sys.exit(1)

print "THIS:%s, DIRPATH:%s, BASEPATH:%s, TENANT:%s" % (THIS, DIRPATH, BASEPATH,TENANT)

FILES_TO_MONITOR = ["top.sh.out", "netstat.sh.out", "dmesg.sh.out"]
FILE_TO_MONITOR_MTIME = [0 , 0 , 0]

POLL_INTERVAL_SECONDS = 3
#ping_interval=30, ping_timeout=10)
def on_message(ws, message):
    print message

def on_close(ws):
    print "### closed ###"

if __name__ == "__main__":
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(BASEPATH, on_message = on_message, on_close = on_close)
    wst = threading.Thread(target=ws.run_forever)
    wst.daemon = True
    wst.start()

    conn_timeout = 5
    while not ws.sock.connected and conn_timeout:
        time.sleep(1)
        conn_timeout -= 1

    msg_counter = 0
    while ws.sock.connected:
        msg_counter += 1
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

                print "Publishing file:[",FILECHANGE,"], - tenant:[",TENANT,"], - channel:[",fileName,"], mtime[",mtime,"], snapShotId",msg_counter,"]"
                #URL = BASEPATH+"pubsub?tenant="+TENANT+"&channel="+fileName
                with open(FILECHANGE, 'r') as file:
                    data = file.read()
                    ws.send(data)
            time.sleep(POLL_INTERVAL_SECONDS)
        except:
            print "Exception in user code:"
            traceback.print_exc(file=sys.stdout)

