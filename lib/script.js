function searchText() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const content = document.getElementById('content');
    const paragraphs = content.getElementsByTagName('p');

    // Loop through all paragraphs and hide or highlight based on the search input
    for (let i = 0; i < paragraphs.length; i++) {
        const paragraph = paragraphs[i];
        const text = paragraph.textContent.toLowerCase();

        // Remove any previous highlights
        paragraph.innerHTML = paragraph.textContent;

        if (text.includes(input) && input !== '') {
            const regex = new RegExp(`(${input})`, 'gi');
            paragraph.innerHTML = paragraph.textContent.replace(regex, `<span class="highlight">$1</span>`);
        }
    }
}
