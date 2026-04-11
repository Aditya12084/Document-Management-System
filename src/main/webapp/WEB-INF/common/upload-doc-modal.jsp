<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="uploadModalLabel">
                    <i class="bi bi-cloud-arrow-up me-2"></i>Submit Document
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="uploadForm" action="#" method="POST" enctype="multipart/form-data">
                <div class="modal-body">

                    <c:if test="${sessionScope.user.role=='ADMIN'}">
                        <div class="mb-3 p-3 rounded" style="background-color: #f0f7ff; border: 1px dashed #0d6efd;">
                            <label class="form-label fw-bold text-primary">Target Customer ID</label>
                            <input type="text" name="targetUserId" class="form-control" placeholder="Enter Account/User ID" required>
                            <div class="form-text">As Admin, specify which user owns this file.</div>
                        </div>
                    </c:if>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Document Category</label>
                        <select class="form-select" id="docCategory" name="docCategory" required>
                            <option value="" selected disabled>Choose category...</option>
                            <option value="IDENTITY">KYC / Identity</option>
                            <option value="LOAN_DOC">Loan Agreement</option>
                            <option value="STATEMENTS">Bank Statements</option>
                            <option value="SANCTION">Sanction Letter</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Select File</label>
                        <input type="file" name="file" class="form-control" accept=".pdf,.jpg,.png" required>
                        <div class="form-text">Accepted: PDF, JPG, PNG (Max 5MB)</div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" id="upload-doc-btn" class="btn btn-primary px-4">
                        <i class="bi bi-check-circle me-1"></i>Upload Now
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>