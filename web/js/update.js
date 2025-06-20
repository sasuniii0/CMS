document.querySelector('form').addEventListener('submit', function(e) {
    const remarks = document.getElementById('remarks').value.trim();
    if (remarks === '') {
        e.preventDefault();
        alert('Remarks field is required');
        document.getElementById('remarks').focus();
    }
});

document.getElementById('status').addEventListener('change', function() {
    const status = this.value;
    const remarks = document.getElementById('remarks');
    if (status === 'resolved' || status === 'rejected') {
        remarks.disabled = false;
    } else {
        remarks.disabled = true;
        remarks.value = '';
    }
    remarks.focus();
    remarks.select();
})

document.ready(function() {
    const status = document.getElementById('status').value;
    const remarks = document.getElementById('remarks');
    if (status === 'resolved' || status === 'rejected') {

        remarks.disabled = false;
    } else {
        remarks.disabled = true;
        remarks.value = '';
    }
})