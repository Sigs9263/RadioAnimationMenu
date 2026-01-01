document.addEventListener('DOMContentLoaded', () => {
    function playSound(soundType) {
        const soundId = soundType === 'on' ? 'radioOnSound' : 'radioOffSound';
        const audio = document.getElementById(soundId);
        if (audio) {
            audio.currentTime = 0;
            audio.play().catch(err => console.error('Sound play error:', err));
        }
    }

    window.addEventListener('message', (event) => {
        const data = event.data;
        if (data.type === 'playSound') {
            playSound(data.sound);
        }
    });
});
