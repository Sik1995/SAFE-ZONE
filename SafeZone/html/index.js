
window.addEventListener('message', function(event) {
    var ed = event.data

    switch(ed.action) {
        case 'show':
        $('.Container').show(100)
        $('.Background').show(100)
        break;

        case 'hide':
        $('.Container').hide(0)
        $('.Background').hide(0)
    }
})

window.addEventListener('message', function(event) {
    var ed = event.data

    switch(ed.action) {
        case 'show1':
        $('.RzContainer').show(100)
        $('.RzBackground').show(100)
        break;

        case 'hide1':
        $('.RzContainer').hide(0)
        $('.RzBackground').hide(0)
    }
})