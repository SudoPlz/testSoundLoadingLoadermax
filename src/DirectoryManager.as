/**
 * Created by Dynopia on 1/30/14.
 */
package {
import flash.filesystem.File;

public class DirectoryManager {

    private static var instance:DirectoryManager;
    private static var allowInstantiation:Boolean;


    //directories
    public static const IOS_CACHE_DIR:String = "/\.\./Library/Caches";
    public static const ANDROID_CACHE_DIR:String = "/FTCache";

    public static const TALES_PATH:String = "/tales/tale_";
    public static const PAGES_PATH:String = "/page_";
    public static const DEFAULT_TALE_PATH:String = "assets/defaultTale";


    //files
    public static const PAGE_SOUND_FILENAME:String = "/pagesound";

    public static const DEFAULT_APP_FAIRYTALE:int = 1;


    private var _isIos:Boolean;
    private var cacheDir:String;

    public function DirectoryManager() {
        if (!allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use DirectoryManager.getInstance() instead of new.");
        }
    }

    public static function getInstance():DirectoryManager {
        if (instance == null) {
            allowInstantiation = true;
            instance = new DirectoryManager();
            allowInstantiation = false;
        }
        return instance;
    }

    public function getCacheDirectoryPath():String
    {
        if (!cacheDir)
        {
            var str:String = (isIos ? File.applicationDirectory.nativePath : File.applicationStorageDirectory.nativePath);
            var tempFile:File = new File(str + (isIos? IOS_CACHE_DIR: ANDROID_CACHE_DIR) );				//cache folder (in which you put files that you dont care being erased. the iOs might delete those files in case of low memory
            cacheDir = tempFile.url;
        }
        return cacheDir;
    }
    public function getTalePathById(taleId:uint):String
    {
        //get tale dir
        if(taleId==DEFAULT_APP_FAIRYTALE)
        {
           return DEFAULT_TALE_PATH +"/";
        }
        else
        {
            return getCacheDirectoryPath() + TALES_PATH + taleId.toString()+"/";    //either dl'ed tales dir (cache), or default tale dir (app storage)
        }
    }


    public function getTaleDownloadedZipPath(taleId:uint):String
    {
        return (getCacheDirectoryPath() + TALES_PATH + taleId.toString() + "tale_"+ taleId.toString() + "_assets.zip");
    }

    public function sortDirectoryBasedOnFilename( fileName:String, taleId:uint):String
    {

        var filePath:String = TALES_PATH + taleId.toString();

        var sorter:int = fileName.indexOf("_")
        if ( sorter == -1 )	//if u cant find _ within the name then its a global tale file
        {
            filePath = "/"+fileName;
        }
        else
        {
            var fileNameParts:Array = fileName.split("_");
            var pageId:String = ( fileNameParts[1] as String).slice(0,1);
            filePath += PAGES_PATH + pageId;
            var details:String = "";
            try{
                details = "_"+fileNameParts[2];
            }catch (e:Error){}

            var filenameEnding:String = PAGE_SOUND_FILENAME+details; //+".mp3";
            filePath += filenameEnding;
            filePath = filePath.substr(1); //this is to remove the / in front of the filepath
        }
        return filePath;
    }


    public function get isIos():Boolean {
        return _isIos;
    }

    public function set isIos(value:Boolean):void {
        _isIos = value;
    }
}
}