/**
 * Handled all the playback for every audio plauer
 */
$(function(){

//initialize all the registered sound clips, then delete their global reference
    _.each(GF.clips, function(clip){
        GF.soundManager.createSound({
            'id' : clip.id,
            'url' : clip.url,
            'autoLoad' : true,
            'autoPlay' : false
        });
    });
    //clean up the global crap that we created for clip registration
    delete GF.clips;
    delete GF.registerSoundClip;


//sound playing handler - start/pauses a clip
    function playSound(event)
    {
        //event play and restart button has a data-sid attribute, which indicated the soundID that it controlsl
        var target = event.target
            soundId = target.attributes['data-sid'].value;

        //get the closest progress bar item
        var progressBar = $(target).siblings('.audio-player-progress-wrapper').find('.audio-player-progress');

        //get the sound element we want to control
        var activceSound = GF.soundManager.getSoundById(soundId);

        //determine if we need to pause the clip, or play it
        if(activceSound.position > 0 && !activceSound.paused)
        {
            GF.soundManager.pause(soundId);
        }else{
            GF.soundManager.play(soundId, {
                onfinish : function(){
                    $(target).removeClass('icon-pause').addClass('icon-play');
                },
                onplay : function(){
                    $(target).removeClass('icon-play').addClass('icon-pause');
                    progressBar.width(0);
                },
                onpause : function(){
                    $(target).removeClass('icon-pause').addClass('icon-play');
                },
                onresume : function(){
                    $(target).removeClass('icon-play').addClass('icon-pause');
                },
                whileplaying : function(){
                    var progress = (this.position / this.duration) * 100;
                    progressBar.width(progress + '%');
                    
                }
            });
        }
    }

//handles the clips restart action (this is currently not being used)
    function restartSound(event)
    {
        var target = event.target,
            soundId = target.attributes['data-sid'].value;
            
        var activceSound = GF.soundManager.getSoundById(soundId);
            activceSound.stop();
            activceSound.play();
    }

    $('.audio-playet-btn-restart').click( restartSound );
    $('.audio-playet-btn-play').click( playSound );

})
