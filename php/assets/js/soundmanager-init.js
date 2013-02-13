//initialize the global namespace for Gramofon
GF = {};

//create an array for registered clips
GF.clips = [];

//inistianciate SoundManager2
GF.soundManager = soundManager.setup({
    //useFlashBlock : false,
    preferFlash : false,
    //useHTML5Audio : true,
    onready : function(){
       console.log('-----> ready!');
    }
});

/*
 *  global helpfer function
 * it's purpose is to allow individual audio clips to register them sef.
 * registratrion takes place as soon as the clip is loaded (aka: in-line JS inside audio-clip-player.php)
 * 
 * there might be a way to clean this up... but this was the quickest, cleanest implementation I could come up with given the time I had 
 */ 
GF.registerSoundClip = function (id, url)
{
    var clipObject = {};
    clipObject.id = id;
    clipObject.url = url;
    
    GF.clips.push(clipObject);
}
