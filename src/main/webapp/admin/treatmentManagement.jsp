<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.model.TreatmentType" %>

<%
    String contextPath = request.getContextPath();

    String staffName = (String) session.getAttribute("staffName");
    if (staffName == null || staffName.isBlank()) {
        staffName = "Administrator";
    }

    List<TreatmentType> treatmentTypes = (List<TreatmentType>) request.getAttribute("treatmentTypes");
    if (treatmentTypes == null) {
        treatmentTypes = new java.util.ArrayList<>();
    }

    String searchKeyword = (String) request.getAttribute("searchKeyword");
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");

    String adminInitials = "AD";
    if (staffName != null && !staffName.isBlank()) {
        String[] parts = staffName.trim().split("\\s+");
        if (parts.length >= 2) {
            adminInitials = (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
        } else if (staffName.length() >= 2) {
            adminInitials = staffName.substring(0, 2).toUpperCase();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treatment Management | Sunrise Dental Clinic</title>

    <!-- Google Fonts Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="<%= contextPath %>/css/reception.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .treatment-header-card {
            background: linear-gradient(135deg, rgba(14, 165, 180, 0.9), rgba(8, 127, 140, 0.95));
            border-radius: 20px;
            padding: 28px 32px;
            color: #ffffff;
            margin-bottom: 25px;
            box-shadow: 0 15px 35px rgba(8, 127, 140, 0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .treatment-header-text h2 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .treatment-header-text p {
            font-size: 13.5px;
            color: #d6f4f8;
            margin: 0;
        }

        .add-treatment-btn {
            background: #ffffff;
            color: #078c9b;
            border: none;
            padding: 12px 22px;
            border-radius: 12px;
            font-size: 13.5px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            transition: all 0.2s ease;
        }

        .add-treatment-btn:hover {
            transform: translateY(-2px);
            background: #f0fbfe;
            color: #056b77;
        }

        .treatment-table-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(6, 38, 50, 0.09);
            padding: 28px 30px;
            margin-bottom: 30px;
            border: 1px solid #edf3f5;
        }

        .treatment-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 22px;
            flex-wrap: wrap;
        }

        .search-box-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            max-width: 400px;
        }

        .search-input-field {
            position: relative;
            flex: 1;
        }

        .search-input-field i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #8da4ae;
            font-size: 14px;
        }

        .search-input-field input {
            width: 100%;
            height: 40px;
            border: 1.5px solid #dce8ec;
            border-radius: 10px;
            padding: 0 14px 0 38px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            box-sizing: border-box;
        }

        .search-input-field input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
        }

        .search-submit-btn {
            background: #0c3d4f;
            color: #ffffff;
            border: none;
            padding: 0 18px;
            height: 40px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .clear-search-btn {
            color: #d9534f;
            font-size: 12.5px;
            font-weight: 600;
            text-decoration: none;
        }

        .treatment-icon-box {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: #e6f7f9;
            color: #078c9b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .action-btn-circle {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            border: 1px solid #e1ecef;
            background: #fbfdfe;
            color: #557280;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .action-btn-circle:hover {
            background: #e6f7f9;
            color: #078c9b;
            border-color: #0ea5b4;
        }

        .action-btn-circle.status-toggle:hover {
            background: #fff5ed;
            color: #d48e0c;
        }

        /* Alerts */
        .alert {
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
        }
        .alert-success { background: #e8f8f0; color: #0d8248; border: 1px solid #c2eed5; }
        .alert-error { background: #feecee; color: #c92a2a; border: 1px solid #f9c6cb; }

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(7, 43, 56, 0.65);
            backdrop-filter: blur(5px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 2000;
            padding: 20px;
        }
        .modal-overlay.show { display: flex; }

        .modal {
            background: #ffffff;
            border-radius: 20px;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: modalFadeIn 0.2s ease;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(15px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .modal-header {
            padding: 22px 28px;
            border-bottom: 1px solid #edf3f5;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fafcfe;
        }
        .modal-header h3 { font-size: 18px; font-weight: 700; color: #0c3d4f; margin: 0; }

        .modal-close {
            border: none; background: transparent; font-size: 18px; color: #8da4ae; cursor: pointer;
        }
        .modal-close:hover { color: #d9534f; }

        .modal-body {
            padding: 26px 28px;
        }

        .form-group {
            margin-bottom: 18px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-size: 12.5px;
            font-weight: 600;
            color: #3b5663;
        }

        .form-group input {
            height: 42px;
            border: 1.5px solid #dce8ec;
            border-radius: 10px;
            padding: 0 14px;
            font-size: 13px;
            color: #123847;
            background: #fbfdfe;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-group input:focus {
            border-color: #0ea5b4;
            background: #ffffff;
        }

        .modal-footer {
            padding: 18px 28px;
            border-top: 1px solid #edf3f5;
            background: #fafcfe;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .secondary-button {
            padding: 10px 18px;
            border-radius: 10px;
            border: 1px solid #dce8ec;
            background: #ffffff;
            color: #557280;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .modal-submit {
            padding: 10px 22px;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(8, 127, 140, 0.25);
        }
    </style>
</head>

<body>

<div class="dashboard-container">

    <!-- ========================================= -->
    <!-- SIDEBAR -->
    <!-- ========================================= -->
    <aside class="sidebar" id="sidebar">

        <div class="sidebar-brand">
            <img src="<%= contextPath %>/images/logo1.png" alt="Sunrise Dental Clinic Logo">
            <div class="brand-text">
                <h2>Sunrise</h2>
                <span>Dental Clinic</span>
            </div>
        </div>

        <nav class="sidebar-navigation">
            <p class="navigation-title">MAIN</p>

            <a href="<%= contextPath %>/admin/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="<%= contextPath %>/admin/staff" class="nav-item">
                <i class="bi bi-people-fill"></i>
                <span>Staff Management</span>
            </a>

            <a href="<%= contextPath %>/admin/dentist-slots" class="nav-item">
                <i class="bi bi-clock-history"></i>
                <span>Dentist Time Slots</span>
            </a>

            <a href="<%= contextPath %>/admin/treatments" class="nav-item active">
                <i class="bi bi-journal-medical"></i>
                <span>Treatments</span>
            </a>

            <p class="navigation-title clinic-title">ANALYTICS</p>

            <a href="<%= contextPath %>/admin/dashboard" class="nav-item">
                <i class="bi bi-bar-chart-line-fill"></i>
                <span>Reports</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p class="navigation-title">ACCOUNT</p>
            <a href="<%= contextPath %>/logout" class="nav-item logout-item">
                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>
            </a>
        </div>

    </aside>

    <!-- ========================================= -->
    <!-- MAIN CONTENT -->
    <!-- ========================================= -->
    <main class="main-content">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar-left">
                <h1>Treatment Management</h1>
                <p>Manage treatment types, procedures, and basic pricing</p>
            </div>

            <div class="topbar-right">
                <button type="button" class="icon-button" title="Notifications">
                    <i class="bi bi-bell"></i>
                    <span class="notification-dot"></span>
                </button>

                <div class="user-profile">
                    <div class="user-avatar">
                        <i class="bi bi-person-gear"></i>
                    </div>
                    <div class="user-information">
                        <strong><%= staffName %></strong>
                        <span>Administrator</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- CONTENT -->
        <section class="dashboard-content">

            <!-- Hero Banner -->
            <div class="treatment-header-card">
                <div class="treatment-header-text">
                    <h2>Clinic Treatment Catalogue</h2>
                    <p>Maintain standard clinical procedures and default treatment fees.</p>
                </div>
                <button type="button" class="add-treatment-btn" onclick="openAddModal()">
                    <i class="bi bi-plus-circle-fill"></i> Add New Treatment
                </button>
            </div>

            <!-- Messages -->
            <% if (successMessage != null && !successMessage.isBlank()) { %>
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill"></i>
                    <span><%= successMessage %></span>
                </div>
            <% } %>

            <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                <div class="alert alert-error">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <!-- Table Card -->
            <div class="treatment-table-card">
                <div class="treatment-card-header">
                    <div>
                        <h3 style="font-size: 17px; font-weight: 700; color: #0c3d4f; margin: 0;">Treatment Types (<%= treatmentTypes.size() %>)</h3>
                        <p style="font-size: 12.5px; color: #7a94a2; margin: 2px 0 0;">Configured dental treatments and basic charges</p>
                    </div>

                    <!-- Search Form -->
                    <form method="get" action="<%= contextPath %>/admin/treatments" class="search-box-wrap">
                        <div class="search-input-field">
                            <i class="bi bi-search"></i>
                            <input type="text" name="search" placeholder="Search treatment types..." value="<%= searchKeyword != null ? searchKeyword : "" %>">
                        </div>
                        <button type="submit" class="search-submit-btn">Search</button>
                        <% if (searchKeyword != null && !searchKeyword.isBlank()) { %>
                            <a href="<%= contextPath %>/admin/treatments" class="clear-search-btn">Clear</a>
                        <% } %>
                    </form>
                </div>

                <div class="table-container">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Treatment Name</th>
                                <th>Basic Cost</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            boolean found = false;
                            String search = searchKeyword != null ? searchKeyword.trim().toLowerCase() : "";

                            for (TreatmentType treatmentType : treatmentTypes) {
                                String treatmentName = treatmentType.getTreatmentName();
                                if (!search.isEmpty() && (treatmentName == null || !treatmentName.toLowerCase().contains(search))) {
                                    continue;
                                }

                                found = true;
                                String status = treatmentType.getStatus();
                                String statusClass = "ACTIVE".equalsIgnoreCase(status) ? "status-confirmed" : "status-cancelled";
                        %>
                            <tr>
                                <td>
                                    <strong style="color: #0c3d4f; font-size: 13px;">#<%= treatmentType.getTreatmentTypeId() %></strong>
                                </td>
                                <td>
                                    <div class="patient-cell">
                                        <div class="treatment-icon-box">
                                            <i class="bi bi-heart-pulse"></i>
                                        </div>
                                        <div>
                                            <strong><%= treatmentName %></strong>
                                            <span>Dental Procedure</span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <strong style="color: #0c3d4f; font-size: 14px;">Rs. <%= String.format("%,.2f", treatmentType.getBasicCost()) %></strong>
                                </td>
                                <td>
                                    <span class="status <%= statusClass %>"><%= status %></span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <button type="button" class="action-btn-circle" title="Edit Treatment"
                                                onclick="openEditModal('<%= treatmentType.getTreatmentTypeId() %>', '<%= escapeJs(treatmentType.getTreatmentName()) %>', '<%= treatmentType.getBasicCost() %>')">
                                            <i class="bi bi-pencil"></i>
                                        </button>

                                        <form method="post" action="<%= contextPath %>/admin/treatments" style="display:inline;">
                                            <input type="hidden" name="action" value="changeStatus">
                                            <input type="hidden" name="treatmentTypeId" value="<%= treatmentType.getTreatmentTypeId() %>">

                                            <% if ("ACTIVE".equalsIgnoreCase(status)) { %>
                                                <button type="submit" class="action-btn-circle status-toggle" title="Deactivate"
                                                        onclick="return confirm('Are you sure you want to deactivate this treatment type?');">
                                                    <i class="bi bi-pause-circle"></i>
                                                </button>
                                            <% } else { %>
                                                <button type="submit" class="action-btn-circle" title="Activate"
                                                        onclick="return confirm('Are you sure you want to activate this treatment type?');">
                                                    <i class="bi bi-play-circle"></i>
                                                </button>
                                            <% } %>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%
                            }
                            if (!found) {
                        %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 45px 20px; color: #8da4ae;">
                                    <i class="bi bi-search" style="font-size: 36px; display: block; margin-bottom: 8px; color: #b0c9d4;"></i>
                                    No treatment types found matching your search.
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

        </section>

    </main>

</div>

<!-- ========================================= -->
<!-- ADD TREATMENT MODAL -->
<!-- ========================================= -->
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Add Treatment Type</h3>
            <button type="button" class="modal-close" onclick="closeAddModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <form method="post" action="<%= contextPath %>/admin/treatments">
            <input type="hidden" name="action" value="add">

            <div class="modal-body">
                <div class="form-group">
                    <label>Treatment Name <span style="color: #d9534f;">*</span></label>
                    <input type="text" name="treatmentName" placeholder="e.g. Dental Scaling & Polishing" required>
                </div>

                <div class="form-group">
                    <label>Basic Cost (Rs.) <span style="color: #d9534f;">*</span></label>
                    <input type="number" name="basicCost" min="0" step="0.01" placeholder="0.00" required>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="secondary-button" onclick="closeAddModal()">Cancel</button>
                <button type="submit" class="modal-submit"><i class="bi bi-check-lg"></i> Save Treatment</button>
            </div>
        </form>
    </div>
</div>

<!-- ========================================= -->
<!-- EDIT TREATMENT MODAL -->
<!-- ========================================= -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Edit Treatment Type</h3>
            <button type="button" class="modal-close" onclick="closeEditModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <form method="post" action="<%= contextPath %>/admin/treatments">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="treatmentTypeId" id="editTreatmentTypeId">

            <div class="modal-body">
                <div class="form-group">
                    <label>Treatment Name <span style="color: #d9534f;">*</span></label>
                    <input type="text" name="treatmentName" id="editTreatmentName" required>
                </div>

                <div class="form-group">
                    <label>Basic Cost (Rs.) <span style="color: #d9534f;">*</span></label>
                    <input type="number" name="basicCost" id="editBasicCost" min="0" step="0.01" required>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="secondary-button" onclick="closeEditModal()">Cancel</button>
                <button type="submit" class="modal-submit"><i class="bi bi-check-lg"></i> Update Treatment</button>
            </div>
        </form>
    </div>
</div>

<script>
function openAddModal() {
    document.getElementById("addModal").classList.add("show");
}

function closeAddModal() {
    document.getElementById("addModal").classList.remove("show");
}

function openEditModal(id, name, cost) {
    document.getElementById("editTreatmentTypeId").value = id;
    document.getElementById("editTreatmentName").value = name;
    document.getElementById("editBasicCost").value = cost;
    document.getElementById("editModal").classList.add("show");
}

function closeEditModal() {
    document.getElementById("editModal").classList.remove("show");
}

document.getElementById("addModal").addEventListener("click", function(e) { if (e.target === this) closeAddModal(); });
document.getElementById("editModal").addEventListener("click", function(e) { if (e.target === this) closeEditModal(); });
document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
        closeAddModal();
        closeEditModal();
    }
});
</script>

<%!
    private String escapeJs(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"").replace("\r", "\\r").replace("\n", "\\n");
    }
%>

</body>
</html>