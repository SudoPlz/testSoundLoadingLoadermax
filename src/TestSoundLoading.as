package {

import com.greensock.events.LoaderEvent;
import com.greensock.loading.LoaderMax;
import com.greensock.loading.MP3Loader;
import com.greensock.loading.XMLLoader;

import flash.display.Sprite;
import flash.text.TextField;

public class TestSoundLoading extends Sprite {
    private var curTaleDirectory:String;
    private var loader:LoaderMax;
    private var xmlLoader:XMLLoader;
    private var curTalePageCnt:uint;
    private var _taleId:int;
    

    /*
    *
    * Purpose: Load an xml, which has MP3Loaders inside,
    * and load those mp3loaders as well
    *       (but make sure you add a prefix just before they load,
    *        perhaps by using recursivePrependURL)
    *
    *
    *   Instructions:
    *       1) before running the project,
    *       make sure you've added the 'assets' folder in mobile app package,
    *       so that it copies the files to the phone.
    *
    *       2) Use it on a device or a simulator/emulator so that the files get transferred in it (I use iOs simulator)
    * */

    public function TestSoundLoading() {

        _taleId = 1;
        //load the properties file for this tale
        loader = new LoaderMax({name:"tale$"+_taleId.toString()+"_props", autoDispose :true, onComplete:propsLoaded});
        LoaderMax.activate([MP3Loader]); //only necessary once - allows XMLLoader to recognize MP3Loader nodes inside the XML
        curTaleDirectory = DirectoryManager.getInstance().getTalePathById(_taleId);
        xmlLoader = new XMLLoader(curTaleDirectory + "xmlprops.xml", {name:"xmlprops_tale$"+_taleId.toString(),

            recursivePrependURLs:curTaleDirectory, //TODO: Using this line results in MP3Loader Error

            context:"own", autoDispose :true,  estimatedBytes:841 })
        loader.append(xmlLoader);
        loader.load();
    }

    private function propsLoaded(e:LoaderEvent):void {
        trace("XML Loaded")
        var objects:Array = e.currentTarget.content;
        var taleProps:XML = objects[0];     // This ONLY works on mobile devices..!

        try
        {
            //get the properties contained within the props file and store them in this object
            curTalePageCnt = taleProps.pageCnt;
        } catch (e:Error){trace("Page xml parse error: "+ e.message)}

        for (var pageId:uint=0;pageId<curTalePageCnt;pageId++) //for each page
        {
            try{   //try getting our hands on the LoaderMax instance
                var pageSoundsLoader:LoaderMax = loader.getLoader("ft$"+_taleId.toString()+":page$"+(pageId+1).toString()); //get the pages LoaderMax stored within the xml
            }catch (e:Error){
                trace("Page xml parse error: "+ e.message + " on page: " + (pageId+1).toString());
            }



            //TODO: check the pageSoundsLoader.. is it full? is it empty?
            trace(pageSoundsLoader); //usually this is filled with 2 empty sounds.




        }
    }
}
}
