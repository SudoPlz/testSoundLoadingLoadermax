/**
 * Created by Dynopia on 1/30/14.
 */
package {
import flash.filesystem.File;

public class DirectoryManager {

    //directories
    public static const IOS_CACHE_DIR:String = "/\.\./Library/Caches";
    public static const ANDROID_CACHE_DIR:String = "/FTCache";

    public static const TALES_PATH:String = "/tales/tale_";
    public static const DEFAULT_TALE_PATH:String = "assets/defaultTale";


    public static const DEFAULT_APP_FAIRYTALE:int = 1;


    private var _isIos:Boolean;
    private var cacheDir:String;

    public function DirectoryManager(isIos:Boolean = true) {
         _isIos = isIos;
    }


    public function getCacheDirectoryPath():String
    {
        if (!cacheDir)
        {
            var str:String = (_isIos ? File.applicationDirectory.nativePath : File.applicationStorageDirectory.nativePath);
            var tempFile:File = new File(str + (_isIos? IOS_CACHE_DIR: ANDROID_CACHE_DIR) );				//cache folder (in which you put files that you dont care being erased. the iOs might delete those files in case of low memory
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


}
}