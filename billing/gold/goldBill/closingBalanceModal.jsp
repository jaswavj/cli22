<!-- Closing Balance Modal -->
<div class="modal fade" id="closingBalanceModal" tabindex="-1" aria-labelledby="closingBalanceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #1a2540 0%, #c9a227 100%); color: white;">
                <h5 class="modal-title" id="closingBalanceModalLabel">
                    <i class="fa-solid fa-scale-balanced me-2"></i>Add Closing Balance
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info">
                    <i class="fa-solid fa-info-circle me-2"></i>
                    Enter today's closing balance (<span id="closingBalanceDate"></span>)
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Closing Balance Amount</label>
                    <input type="number" step="0.01" id="closingBalanceAmount" class="form-control" placeholder="0.00" required>
                </div>
                <div id="closingBalanceError" class="alert alert-danger d-none"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="btnSaveClosingBalance">
                    <i class="fa-solid fa-save me-1"></i>Save
                </button>
            </div>
        </div>
    </div>
</div>

<script>
let closingBalanceModal;

function initClosingBalanceModal() {
    closingBalanceModal = new bootstrap.Modal(document.getElementById('closingBalanceModal'));
    document.getElementById('closingBalanceDate').textContent = new Date().toLocaleDateString('en-GB');

    document.getElementById('btnSaveClosingBalance').addEventListener('click', function() {
        saveClosingBalance();
    });

    document.getElementById('closingBalanceAmount').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            saveClosingBalance();
        }
    });
}

function showClosingBalanceModal() {
    if (!closingBalanceModal) {
        initClosingBalanceModal();
    }
    document.getElementById('closingBalanceAmount').value = '';
    document.getElementById('closingBalanceError').classList.add('d-none');
    closingBalanceModal.show();
    setTimeout(function() {
        document.getElementById('closingBalanceAmount').focus();
    }, 300);
}

function saveClosingBalance() {
    const amount = document.getElementById('closingBalanceAmount').value;
    const errorDiv = document.getElementById('closingBalanceError');

    if (!amount || parseFloat(amount) < 0) {
        errorDiv.textContent = 'Please enter a valid amount';
        errorDiv.classList.remove('d-none');
        return;
    }

    const btn = document.getElementById('btnSaveClosingBalance');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Saving...';

    fetch('<%= request.getContextPath() %>/gold/goldBill/saveClosingBalance.jsp?balance=' + encodeURIComponent(amount))
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.status === 'ok') {
                closingBalanceModal.hide();
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Closing balance saved successfully',
                    timer: 2000,
                    showConfirmButton: false
                });
            } else {
                errorDiv.textContent = data.message || 'Failed to save closing balance';
                errorDiv.classList.remove('d-none');
            }
        })
        .catch(function(error) {
            errorDiv.textContent = 'Error: ' + error.message;
            errorDiv.classList.remove('d-none');
        })
        .finally(function() {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-save me-1"></i>Save';
        });
}

if (typeof window !== 'undefined') {
    initClosingBalanceModal();
}
</script>
