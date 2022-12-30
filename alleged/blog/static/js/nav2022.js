const handleToggle = async e => {
    const elt = e.currentTarget;
    const res = await fetch(elt.dataset.nav);
    elt.outerHTML = await res.text();
}

document.querySelectorAll('*[data-nav]').forEach(elt => {
    const s = elt.querySelector('summary');
    s.innerText = s.querySelector('a').innerText;
    elt.addEventListener('toggle', handleToggle);
})
