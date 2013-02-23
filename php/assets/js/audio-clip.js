// Gramofon audioClip jQueryUI widget
(function( $ ) {
    $.widget( 'gramofon.audioClip', {
        options: {
            id: null,
            url: null,
            sound: null,
            state: null
        },

        _init: function() {
            var self = this;

            // create the sound instance
            self.options.sound = soundManager.createSound({
                'id': this.options.id,
                'url': this.options.url
            });

            // play/pause button click handler
            self.element.find('.audio-player-btn-play').click(function() {
                self.playPause();
            });

            // click in scrubber/progress
            self.element.find('.audio-player-progress-wrapper').click(function(e) {
                var $this = $(this),
                    parentOffset = $this.offset(),
                    parentWidth = $this.width(),
                    offset = e.pageX - parentOffset.left,
                    percent = offset / parentWidth;
                    
                self.seek( percent );
            });
        },

        playPause: function( startPercentage ) {
            var self     = this,
                sound    = self.options.sound,
                button   = self.element.find('.audio-player-btn-play'),
                progress = self.element.find('.audio-player-progress');

            if ( sound.position == null || sound.playState == 0 ) {
                sound.play({
                    onload: function() {
                        var duration = sound.duration || sound.durationEstimate,
                            startPosition = 0;
                        
                        if ( startPercentage ) {
                            startPosition = Math.floor( duration * startPercentage );
                            this.setPosition( startPosition );
                        }
                    },
                    onplay: function() {                        
                        button.removeClass('icon-play').addClass('icon-pause');
                        progress.width(0);
                    },
                    onpause: function() {
                        button.removeClass('icon-pause').addClass('icon-play');
                    },
                    onresume : function(){
                        button.removeClass('icon-play').addClass('icon-pause');
                    },
                    whileplaying : function(){
                        progress.width( ( this.position / this.duration ) * 100 + '%' );
                    },
                    onfinish: function() {
                        sound.setPosition(0);
                        button.removeClass('icon-pause').addClass('icon-play');
                        progress.width( '0%' );
                        // todo: increment play count in API
                    }
                });
            } else if ( sound.position > 0 && ! sound.paused ) {                
                sound.pause();
            } else {
                sound.resume();
            }
        },

        seek: function( percent ) {
            var seekPosition,
                sound = this.options.sound;

            if ( sound.loaded ) {
                seekPosition = Math.floor( sound.duration * percent );                
                sound.setPosition( seekPosition );
                
                if ( sound.playState == 0 ) {
                    this.playPause( percent );
                }
            } else {
                this.playPause( percent );
            }
        }
    });
}( jQuery ) );

// If audio clips exist on the page,
// setup SoundManager and init audioClip widgets
if ( $('.audio-player').length ) {
    soundManager.setup({
        url: '/js/vendor/soundmanager/swf/',
        flashVersion: 9,
        useFlashBlock: false,
        preferFlash: false,
        onready: function() {
            $('.audio-player').each(function(i) {
                var $this = $(this);

                $this.audioClip({
                    id:  $this.data('clip-id'),
                    url: $this.data('clip-url')
                });
            });
        }
    });
}