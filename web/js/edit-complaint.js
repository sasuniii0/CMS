document.getElementById('image').addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (file && file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = function(event) {
            const preview = document.getElementById('imagePreview');
            preview.innerHTML = `<p>New Image Preview:</p>
                                   <img src="${event.target.result}"
                                        class="img-thumbnail preview-image"
                                        alt="Preview of new image">`;
        };
        reader.readAsDataURL(file);
    }
});