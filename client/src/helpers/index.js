export function getParameterByName (name, url) {
    try {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        let regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    } catch (err) {
        return '';
    }
}


export function randomId () {
    return (Math.floor(Math.random() * 10000000) + Date.now()).toString(16)
}