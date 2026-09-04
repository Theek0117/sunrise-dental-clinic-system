<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.sunrise.dental.dao.DentistDAO" %>
<%@ page import="com.sunrise.dental.dao.DentistDAOImpl" %>
<%@ page import="com.sunrise.dental.model.Dentist" %>

<%
    String contextPath = request.getContextPath();
    DentistDAO dentistDAO = new DentistDAOImpl();
    List<Dentist> activeDentists = dentistDAO.findAllActive();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sunrise Dental Clinic | Advanced Dental Care & Specialists</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,600&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    
    <!-- Bootstrap Icons & AOS Animation Library -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" />
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css" />
    <link rel="icon" type="image/png" href="<%= contextPath %>/images/logo1.png">

    <style>
        /* =========================================================
           NEXT-LEVEL STYLING ENHANCEMENTS FOR INDEX PAGE
           ========================================================= */
        :root {
            --brand-teal: #0ea5b4;
            --brand-dark-teal: #087f8c;
            --brand-navy: #0b2545;
            --brand-light: #f0fdfa;
            --glass-bg: rgba(255, 255, 255, 0.85);
            --card-shadow: 0 15px 35px rgba(11, 37, 69, 0.08);
        }

        /* STATS RIBBON */
        .stats-ribbon {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(11, 37, 69, 0.12);
            padding: 30px 40px;
            margin: -50px auto 70px;
            max-width: 1160px;
            position: relative;
            z-index: 10;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            border: 1px solid rgba(14, 165, 180, 0.15);
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .stat-icon {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            background: linear-gradient(135deg, #e6f7f9, #d0f1f4);
            color: var(--brand-teal);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            flex-shrink: 0;
        }

        .stat-text h3 {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            color: var(--brand-navy);
            line-height: 1.1;
        }

        .stat-text p {
            margin: 3px 0 0;
            font-size: 13px;
            color: #64748b;
            font-weight: 500;
        }

        /* DOCTORS SHOWCASE SECTION */
        .doctors-section {
            padding: 90px 24px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .doctors-filter-pills {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 30px auto 45px;
            flex-wrap: wrap;
        }

        .doctor-filter-btn {
            background: #ffffff;
            border: 1.5px solid #dce8ec;
            color: #475569;
            padding: 9px 20px;
            border-radius: 30px;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .doctor-filter-btn:hover, .doctor-filter-btn.active {
            background: var(--brand-teal);
            color: #ffffff;
            border-color: var(--brand-teal);
            box-shadow: 0 6px 18px rgba(14, 165, 180, 0.3);
            transform: translateY(-2px);
        }

        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 28px;
        }

        .doctor-card {
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 12px 35px rgba(11, 37, 69, 0.07);
            border: 1px solid #eef3f6;
            overflow: hidden;
            transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
            cursor: pointer;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        .doctor-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 22px 45px rgba(14, 165, 180, 0.18);
            border-color: rgba(14, 165, 180, 0.4);
        }

        .doctor-card-banner {
            height: 110px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            position: relative;
        }

        .doctor-avatar-wrap {
            width: 86px;
            height: 86px;
            border-radius: 50%;
            background: #ffffff;
            border: 4px solid #ffffff;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
            position: absolute;
            left: 24px;
            bottom: -43px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            color: var(--brand-teal);
            font-weight: 800;
            overflow: hidden;
        }

        .doctor-avatar-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            transition: transform 0.3s ease;
        }

        .doctor-card:hover .doctor-avatar-wrap img {
            transform: scale(1.08);
        }

        .doctor-badge-status {
            position: absolute;
            right: 18px;
            top: 18px;
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
            color: #ffffff;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.4);
        }

        .doctor-card-body {
            padding: 55px 24px 24px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .doctor-card-body h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
            color: var(--brand-navy);
        }

        .doctor-spec-tag {
            color: var(--brand-teal);
            font-size: 13px;
            font-weight: 600;
            margin: 4px 0 12px;
            display: block;
        }

        .doctor-meta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #f8fafc;
            padding: 10px 14px;
            border-radius: 12px;
            margin-bottom: 14px;
            font-size: 12px;
            color: #64748b;
        }

        .doctor-meta-row strong {
            color: var(--brand-navy);
        }

        .doctor-short-bio {
            font-size: 12.5px;
            color: #64748b;
            line-height: 1.6;
            margin-bottom: 20px;
            flex: 1;
        }

        .btn-view-doc-bio {
            width: 100%;
            background: #f0fdfa;
            color: var(--brand-teal);
            border: 1.5px solid #d2e4ea;
            border-radius: 12px;
            padding: 11px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .doctor-card:hover .btn-view-doc-bio {
            background: var(--brand-teal);
            color: #ffffff;
            border-color: var(--brand-teal);
        }

        /* DOCTOR MODAL / DESCRIPTION PANEL */
        .doctor-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(7, 43, 56, 0.7);
            backdrop-filter: blur(8px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 999999;
            padding: 20px;
            animation: modalBackdropFade 0.25s ease;
        }

        .doctor-modal-overlay.show {
            display: flex;
        }

        .doctor-modal-box {
            background: #ffffff;
            border-radius: 28px;
            width: 100%;
            max-width: 620px;
            box-shadow: 0 30px 70px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: modalBoxPop 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
        }

        @keyframes modalBoxPop {
            from { opacity: 0; transform: scale(0.92) translateY(20px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }

        .modal-banner {
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            padding: 28px 30px 45px;
            color: #ffffff;
            position: relative;
        }

        .modal-close-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: #ffffff;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
        }

        .modal-close-btn:hover {
            background: rgba(255, 255, 255, 0.35);
            transform: rotate(90deg);
        }

        .modal-body-scroll {
            padding: 0 32px 32px;
            overflow-y: auto;
            position: relative;
            margin-top: -30px;
        }

        .modal-profile-header {
            display: flex;
            align-items: flex-end;
            gap: 20px;
            margin-bottom: 22px;
        }

        .modal-avatar-lg {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: #ffffff;
            border: 4px solid #ffffff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
            color: var(--brand-teal);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 38px;
            font-weight: 800;
            flex-shrink: 0;
            overflow: hidden;
        }

        .modal-avatar-lg img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .modal-bio-para {
            background: #f8fafc;
            border-left: 4px solid var(--brand-teal);
            padding: 16px 20px;
            border-radius: 0 14px 14px 0;
            font-size: 13.5px;
            color: #334155;
            line-height: 1.8;
            margin: 18px 0;
        }

        .modal-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 20px 0;
        }

        .modal-info-box {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            padding: 14px 16px;
            border-radius: 14px;
        }

        .modal-info-box span {
            font-size: 11.5px;
            color: #64748b;
            display: block;
            font-weight: 600;
            text-transform: uppercase;
        }

        .modal-info-box strong {
            font-size: 13.5px;
            color: var(--brand-navy);
            display: block;
            margin-top: 2px;
        }

        .btn-modal-book-cta {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            color: #ffffff;
            border: none;
            border-radius: 14px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            box-shadow: 0 8px 24px rgba(14, 165, 180, 0.3);
            transition: 0.2s;
        }

        .btn-modal-book-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(14, 165, 180, 0.4);
        }

        /* CALL-TO-BOOK BANNER & CONTACT HUB */
        .call-to-book-banner {
            background: linear-gradient(135deg, #062b38 0%, #0c4d61 100%);
            border-radius: 24px;
            padding: 38px 42px;
            color: #ffffff;
            margin-bottom: 35px;
            box-shadow: 0 20px 45px rgba(6, 43, 56, 0.22);
            border: 1.5px solid rgba(14, 165, 180, 0.35);
            display: flex;
            align-items: center;
            gap: 30px;
            position: relative;
            overflow: hidden;
        }

        .call-to-book-banner::after {
            content: '';
            position: absolute;
            top: -60%;
            right: -20%;
            width: 380px;
            height: 380px;
            background: radial-gradient(circle, rgba(14, 165, 180, 0.25), transparent 70%);
            pointer-events: none;
        }

        .booking-notice-icon {
            width: 80px;
            height: 80px;
            border-radius: 22px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 38px;
            color: #ffffff;
            flex-shrink: 0;
            box-shadow: 0 10px 25px rgba(14, 165, 180, 0.35);
        }

        .booking-notice-content {
            flex: 1;
            position: relative;
            z-index: 1;
        }

        .booking-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(254, 240, 138, 0.18);
            border: 1px solid rgba(254, 240, 138, 0.4);
            color: #fef08a;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 4px 14px;
            border-radius: 20px;
            margin-bottom: 12px;
        }

        .booking-notice-content h2 {
            font-size: 26px;
            font-weight: 800;
            margin: 0 0 10px;
            color: #ffffff;
        }

        .booking-notice-content p {
            font-size: 14.5px;
            color: #cde6ef;
            line-height: 1.7;
            margin: 0 0 22px;
            max-width: 820px;
        }

        .quick-call-actions {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }

        .call-action-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 13px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .call-action-btn.primary {
            background: #0ea5b4;
            color: #ffffff;
            box-shadow: 0 8px 20px rgba(14, 165, 180, 0.35);
        }

        .call-action-btn.primary:hover {
            background: #11b8c9;
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(14, 165, 180, 0.45);
        }

        .call-action-btn.whatsapp {
            background: #25d366;
            color: #ffffff;
            box-shadow: 0 8px 20px rgba(37, 211, 102, 0.3);
        }

        .call-action-btn.whatsapp:hover {
            background: #22bf5b;
            transform: translateY(-2px);
        }

        .call-action-btn.outline {
            background: rgba(255, 255, 255, 0.12);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .call-action-btn.outline:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        .booking-steps-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 30px;
        }

        .booking-step-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 24px 22px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.04);
            display: flex;
            align-items: flex-start;
            gap: 16px;
            transition: all 0.25s ease;
        }

        .booking-step-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 28px rgba(14, 165, 180, 0.12);
            border-color: #a4cddc;
        }

        .step-num {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: #e0f7fa;
            color: var(--brand-teal);
            font-size: 18px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .step-body h4 {
            margin: 0 0 6px;
            font-size: 15px;
            font-weight: 700;
            color: var(--brand-navy);
        }

        .step-body p {
            margin: 0;
            font-size: 12.5px;
            color: #64748b;
            line-height: 1.6;
        }

        /* ENHANCED PROCEDURES SECTION */
        .procedure-card-deluxe {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(11, 37, 69, 0.06);
            border: 1px solid #edf2f7;
            transition: all 0.3s ease;
        }

        .procedure-card-deluxe:hover {
            transform: translateY(-6px);
            border-color: var(--brand-teal);
            box-shadow: 0 18px 40px rgba(14, 165, 180, 0.15);
        }

        @media (max-width: 900px) {
            .stats-ribbon { grid-template-columns: 1fr 1fr; margin-top: 20px; }
            .modal-info-grid { grid-template-columns: 1fr; }
            .call-to-book-banner { flex-direction: column; text-align: center; padding: 30px 24px; }
            .quick-call-actions { justify-content: center; }
            .booking-steps-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 600px) {
            .stats-ribbon { grid-template-columns: 1fr; padding: 20px; }
        }
    </style>
</head>
<body>

    <!-- INTRO LOADER -->
    <div id="intro-loader">
        <svg id="intro-logo" width="225" height="42" viewBox="0 0 225 42" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path id="logo-path" d="M25.8545 32.375C26.4795 32.0208 26.7712 31.3542 26.7295 30.375C26.667 29.2708 25.6982 28.2708 23.8232 27.375C21.9691 26.4583 19.7191 25.5833 17.0732 24.75C15.9691 24.3958 15.1253 24.1146 14.542 23.9062C11.8962 23.0104 9.63574 22.0729 7.76074 21.0938C5.90658 20.1146 4.34408 18.8333 3.07324 17.25C1.80241 15.6667 1.11491 13.7188 1.01074 11.4062C0.927409 9.15625 1.34408 7.25 2.26074 5.6875C3.17741 4.125 4.43783 2.95833 6.04199 2.1875C7.64616 1.39583 9.43783 1 11.417 1H34.1045V8.96875H12.417C11.7295 8.96875 11.0628 9.15625 10.417 9.53125C9.77116 9.88542 9.51074 10.5521 9.63574 11.5312C9.71908 12.2812 10.1878 12.9792 11.042 13.625C11.917 14.25 12.9899 14.8229 14.2607 15.3438C15.5316 15.8438 17.3024 16.4896 19.5732 17.2812C19.8857 17.3854 20.1253 17.4583 20.292 17.5C23.292 18.5417 25.8128 19.5729 27.8545 20.5938C29.917 21.5938 31.667 22.9167 33.1045 24.5625C34.542 26.1875 35.2816 28.1667 35.3232 30.5C35.3857 33.9375 34.4378 36.5312 32.4795 38.2812C30.5212 40.0104 28.0003 40.875 24.917 40.875H2.22949V32.9062H23.9482C24.5941 32.9062 25.2295 32.7292 25.8545 32.375ZM46.3857 17.3125C46.3857 21.2083 47.1878 24.3125 48.792 26.625C50.3962 28.9375 52.3753 30.5625 54.7295 31.5C57.0837 32.4375 59.5003 32.9062 61.9795 32.9062V1H70.5732V40.875H62.2607C57.1357 40.875 52.7295 39.8542 49.042 37.8125C45.3545 35.7708 42.5524 33.0208 40.6357 29.5625C38.7399 26.0833 37.792 22.25 37.792 18.0625V1H46.3857V17.3125ZM86.5107 3.34375C89.8857 4.88542 92.7503 7.21875 95.1045 10.3438V1H103.729V26.9062C103.729 26.9479 103.729 26.9896 103.729 27.0312V40.875H95.1045V28.125C95.1045 26.4792 94.6566 24.6458 93.7607 22.625C92.8649 20.6042 91.6982 18.6875 90.2607 16.875C88.8441 15.0417 87.3649 13.5625 85.8232 12.4375C84.2816 11.2917 82.9066 10.7188 81.6982 10.7188V40.875H73.1045V1H73.917C78.9587 1 83.1566 1.78125 86.5107 3.34375ZM131.011 40.875L119.386 27.9375C117.927 29.1667 116.802 30.6146 116.011 32.2812C115.219 33.9479 114.823 35.9375 114.823 38.25V40.875H106.229V38.25C106.229 34.1875 107.167 30.6562 109.042 27.6562C110.938 24.6562 113.813 21.9479 117.667 19.5312C118.875 18.7604 120.084 18.0938 121.292 17.5312C122.5 16.9479 123.938 16.3021 125.604 15.5938C127.771 14.6771 129.334 13.9271 130.292 13.3438C131.271 12.7396 131.813 12.0209 131.917 11.1875C132.063 10.25 131.834 9.64583 131.229 9.375C130.646 9.10417 129.969 8.96875 129.198 8.96875C129.177 8.96875 129.157 8.96875 129.136 8.96875H106.229V1H130.136C132.032 1 133.792 1.46875 135.417 2.40625C137.063 3.34375 138.344 4.61458 139.261 6.21875C140.198 7.82292 140.625 9.55208 140.542 11.4062C140.417 13.5312 139.802 15.3021 138.698 16.7188C137.615 18.1354 136.302 19.2812 134.761 20.1562C133.219 21.0104 131.136 21.9792 128.511 23.0625C127.865 23.3333 127.386 23.5312 127.073 23.6562L142.573 40.875H131.011ZM145.104 40.875V1H153.698V40.875H145.104ZM181.104 32.375C181.729 32.0208 182.021 31.3542 181.979 30.375C181.917 29.2708 180.948 28.2708 179.073 27.375C177.219 26.4583 174.969 25.5833 172.323 24.75C171.219 24.3958 170.375 24.1146 169.792 23.9062C167.146 23.0104 164.886 22.0729 163.011 21.0938C161.157 20.1146 159.594 18.8333 158.323 17.25C157.052 15.6667 156.365 13.7188 156.261 11.4062C156.177 9.15625 156.594 7.25 157.511 5.6875C158.427 4.125 159.688 2.95833 161.292 2.1875C162.896 1.39583 164.688 1 166.667 1H189.354V8.96875H167.667C166.979 8.96875 166.313 9.15625 165.667 9.53125C165.021 9.88542 164.761 10.5521 164.886 11.5312C164.969 12.2812 165.438 12.9792 166.292 13.625C167.167 14.25 168.24 14.8229 169.511 15.3438C170.782 15.8438 172.552 16.4896 174.823 17.2812C175.136 17.3854 175.375 17.4583 175.542 17.5C178.542 18.5417 181.063 19.5729 183.104 20.5938C185.167 21.5938 186.917 22.9167 188.354 24.5625C189.792 26.1875 190.532 28.1667 190.573 30.5C190.636 33.9375 189.688 36.5312 187.729 38.2812C185.771 40.0104 183.25 40.875 180.167 40.875H157.479V32.9062H179.198C179.844 32.9062 180.479 32.7292 181.104 32.375ZM223.386 24.9375H201.636V32.9062H223.386V40.875H193.042V23.8438C193.042 19.6562 193.99 15.8333 195.886 12.375C197.802 8.89583 200.604 6.13542 204.292 4.09375C207.979 2.03125 212.386 1 217.511 1H223.386V8.96875H217.229C214.354 8.96875 211.604 9.59375 208.979 10.8438C206.375 12.0938 204.427 14.1354 203.136 16.9688H223.386V24.9375Z" fill="transparent" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
    </div>

    <!-- HERO HEADER -->
    <header id="home" class="hero">
        <div class="nav-wrap">
            <nav class="nav">
                <div class="brand" aria-label="Sunrise Dental Clinic">
                    <img src="<%= contextPath %>/images/logo1.png" alt="Sunrise Dental Clinic logo" class="brand-logo" />
                    <div class="brand-text">
                        <strong>Sunrise</strong>
                        DENTAL CLINIC
                    </div>
                </div>

                <div class="menu" id="primaryMenu" aria-label="Main Menu">
                    <a href="#home">Home</a>
                    <a href="#about">About</a>
                    <a href="#services">Services</a>
                    <a href="#doctors">Specialists</a>
                    <a href="#gallery">Gallery</a>
                    
                </div>

                <div class="nav-actions">
                    <a class="login-btn" href="<%= contextPath %>/login.jsp"><i class="bi bi-person-lock"></i> Staff Portal</a>
                    <a class="nav-btn" href="#contact"><i class="bi bi-telephone-fill"></i> Contact Us</a>
                    <button class="menu-toggle" id="menuToggle" aria-label="Open navigation menu" aria-expanded="false">
                        <span></span>
                    </button>
                </div>
            </nav>
        </div>

        <div class="hero-inner">
            <div class="hero-copy" data-aos="fade-right" data-aos-duration="900">
                <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border:1px solid rgba(255,255,255,0.25); padding:6px 14px; border-radius:30px; font-size:12px; font-weight:700; color:#e0f7fa; margin-bottom:16px; backdrop-filter:blur(8px);">
                    <i class="bi bi-award-fill" style="color:#fcd34d;"></i> #1 Rated Modern Dental Clinic
                </div>
                <h1>Smiles That Last<br />a Lifetime</h1>
                <p>
                    Experience world-class dental procedures, pain-free treatments, and award-winning specialist care in a luxurious and calming atmosphere.
                </p>
                <div style="display:flex; gap:14px; flex-wrap:wrap; margin-top:24px;">
                    <a class="primary-btn" href="#contact"><i class="bi bi-telephone-fill"></i> Contact & Appointments</a>
                    <a class="primary-btn" href="#doctors" style="background:rgba(255,255,255,0.15); border:1.5px solid rgba(255,255,255,0.4); backdrop-filter:blur(8px);"><i class="bi bi-people"></i> Meet Our Doctors</a>
                </div>

                <div class="scroll-note">
                    <span class="scroll-icon">↓</span>
                    <span>Scroll to Explore</span>
                </div>
            </div>
        </div>
    </header>

    <main>
        <!-- FLOATING STATS RIBBON -->
        <div class="stats-ribbon" data-aos="fade-up" data-aos-delay="100">
            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-emoji-smile-fill"></i></div>
                <div class="stat-text">
                    <h3>15,000+</h3>
                    <p>Happy Patient Smiles</p>
                </div>
            </div>

            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-shield-check"></i></div>
                <div class="stat-text">
                    <h3>99.8%</h3>
                    <p>Pain-Free Success Rate</p>
                </div>
            </div>

            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-person-badge-fill"></i></div>
                <div class="stat-text">
                    <h3><%= (activeDentists != null && !activeDentists.isEmpty()) ? activeDentists.size() : "8" %>+</h3>
                    <p>Certified Specialists</p>
                </div>
            </div>

            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-clock-history"></i></div>
                <div class="stat-text">
                    <h3>15+ Years</h3>
                    <p>Clinical Excellence</p>
                </div>
            </div>
        </div>

       
        <!-- ========================================================= -->
        <!-- WHY CHOOSE US -->
        <!-- ========================================================= -->
        <section id="about" class="about-section" data-aos="fade-up" data-aos-duration="800">
            <div class="section-kicker">Why choose us</div>
            <h2 class="section-title">Gentle care for every smile</h2>
            <div class="services-grid">
                <article class="service-card">
                    <div class="service-icon"><i class="bi bi-people-fill"></i></div>
                    <h3>Experienced Team</h3>
                    <p>Board-certified specialists focused on pain-free treatments and patient comfort.</p>
                </article>

                <article class="service-card">
                    <div class="service-icon"><i class="bi bi-cpu-fill"></i></div>
                    <h3>Modern Technology</h3>
                    <p>Digital 3D imaging, laser dentistry, and computer-guided implant systems.</p>
                </article>

                <article class="service-card">
                    <div class="service-icon"><i class="bi bi-heart-pulse-fill"></i></div>
                    <h3>Comfort First</h3>
                    <p>A tranquil, spa-like dental environment designed to eliminate dental anxiety.</p>
                </article>

                <article class="service-card">
                    <div class="service-icon"><i class="bi bi-stars"></i></div>
                    <h3>Personalized Plans</h3>
                    <p>Custom-crafted treatment plans tailored precisely to your budget and oral health goals.</p>
                </article>
            </div>
        </section>

        <!-- ========================================================= -->
        <!-- SERVICES & TREATMENTS -->
        <!-- ========================================================= -->
        <section id="services" class="services" data-aos="fade-up" data-aos-duration="800">
            <div class="section-kicker">Premium Clinical Care</div>
            <h2 class="section-title">Comprehensive Dental Services</h2>

            <div class="services-grid">
                <article class="service-card procedure-card-deluxe" data-aos="zoom-in" data-aos-delay="50">
                    <div class="service-icon">🦷</div>
                    <h3>General Dentistry</h3>
                    <p>Routine checkups, hygiene cleanings, pain-free composite fillings, and preventative oral health.</p>
                </article>

                <article class="service-card procedure-card-deluxe" data-aos="zoom-in" data-aos-delay="100">
                    <div class="service-icon">🔩</div>
                    <h3>Dental Implants</h3>
                    <p>Permanent titanium implant anchors and porcelain crowns offering natural chewing and aesthetics.</p>
                </article>

                <article class="service-card procedure-card-deluxe" data-aos="zoom-in" data-aos-delay="150">
                    <div class="service-icon">✨</div>
                    <h3>Cosmetic Dentistry</h3>
                    <p>Porcelain veneers, aesthetic bonding, and Zoom laser teeth whitening for a dazzling smile.</p>
                </article>

                <article class="service-card procedure-card-deluxe" data-aos="zoom-in" data-aos-delay="200">
                    <div class="service-icon">📐</div>
                    <h3>Orthodontics & Aligners</h3>
                    <p>Clear Invisalign aligners and modern ceramic braces to straighten teeth effortlessly.</p>
                </article>
            </div>
        </section>


 <!-- ========================================================= -->
        <!-- MEET OUR EXPERT DENTAL SPECIALISTS SECTION -->
        <!-- ========================================================= -->
        <section id="doctors" class="doctors-section" data-aos="fade-up" data-aos-duration="800">
            <div style="text-align: center;">
                <div class="section-kicker" style="color:var(--brand-teal); font-weight:700; letter-spacing:1px;">✦ Certified Medical Team ✦</div>
                <h2 class="section-title" style="margin-bottom: 8px;">Meet Our Expert Dental Specialists</h2>
                <p style="color:#64748b; font-size:14.5px; max-width:650px; margin:0 auto;">
                    Our dedicated team of renowned surgeons, orthodontists, and aesthetic dentists combine gentle hands with cutting-edge medical technology.
                </p>
            </div>

            <!-- SPECIALTY FILTER PILLS -->
            <div class="doctors-filter-pills">
                <button class="doctor-filter-btn active" onclick="filterDoctors('all', this)">All Specialists</button>
                <button class="doctor-filter-btn" onclick="filterDoctors('orthodontics', this)">Orthodontics</button>
                <button class="doctor-filter-btn" onclick="filterDoctors('cosmetic', this)">Cosmetic Dentistry</button>
                <button class="doctor-filter-btn" onclick="filterDoctors('surgery', this)">Dental Surgery</button>
                <button class="doctor-filter-btn" onclick="filterDoctors('general', this)">General & Pediatric</button>
            </div>

            <!-- DOCTORS GRID -->
            <div class="doctors-grid" id="doctorsContainer">
                <%
                    String[] doctorPhotos = {
                        "https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80",
                        "https://images.unsplash.com/photo-1594824813590-389602e1c981?w=400&auto=format&fit=crop&q=80",
                        "https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80",
                        "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&auto=format&fit=crop&q=80",
                        "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&auto=format&fit=crop&q=80",
                        "https://images.unsplash.com/photo-1622902046580-2b47f47f5471?w=400&auto=format&fit=crop&q=80"
                    };
                    int docIdx = 0;

                    if (activeDentists != null && !activeDentists.isEmpty()) {
                        for (Dentist d : activeDentists) {
                            String docName = d.getName() != null ? d.getName().replaceAll("^(?i)dr\\.?\\s*", "").trim() : "Specialist";
                            String spec = d.getSpecialization() != null && !d.getSpecialization().isBlank() ? d.getSpecialization() : "Dental Surgeon & General Dentist";
                            String room = d.getRoomNumber() != null && !d.getRoomNumber().isBlank() ? d.getRoomNumber() : "Room 101";
                            String initial = docName.length() >= 1 ? docName.substring(0, 1).toUpperCase() : "D";
                            String docPhone = d.getContactNumber() != null ? d.getContactNumber() : "+1 (800) 555-0199";
                            String docEmail = d.getEmail() != null ? d.getEmail() : "doctor@sunrisedental.com";
                            String photoUrl = doctorPhotos[docIdx % doctorPhotos.length];
                            docIdx++;

                            // Categorize for filtering
                            String cat = "general";
                            String lowerSpec = spec.toLowerCase();
                            if (lowerSpec.contains("ortho") || lowerSpec.contains("brace") || lowerSpec.contains("align")) {
                                cat = "orthodontics";
                            } else if (lowerSpec.contains("cosmetic") || lowerSpec.contains("veneer") || lowerSpec.contains("whiten") || lowerSpec.contains("aesthetic")) {
                                cat = "cosmetic";
                            } else if (lowerSpec.contains("surg") || lowerSpec.contains("implant") || lowerSpec.contains("maxillofacial") || lowerSpec.contains("extract")) {
                                cat = "surgery";
                            }

                            // Generate rich biography paragraph
                            String bioParagraph = "Dr. " + docName + " is a distinguished " + spec + " at Sunrise Dental Clinic with extensive clinical experience. Renowned for a gentle and patient-centered approach, Dr. " + docName + " specializes in modern dental restorations, precision diagnostics, and painless treatments. Patients appreciate their meticulous attention to detail, calming chairside manner, and dedication to crafting natural, healthy smiles that boost confidence.";
                %>
                <div class="doctor-card" data-category="<%= cat %>" onclick="openDoctorModal('<%= docName.replace("'", "\\'") %>', '<%= spec.replace("'", "\\'") %>', '<%= room.replace("'", "\\'") %>', '<%= docPhone.replace("'", "\\'") %>', '<%= docEmail.replace("'", "\\'") %>', '<%= bioParagraph.replace("'", "\\'") %>', '<%= initial %>', '<%= photoUrl %>')">
                    <div class="doctor-card-banner">
                        <span class="doctor-badge-status"><i class="bi bi-circle-fill" style="color:#4ade80; font-size:8px;"></i> Available</span>
                        <div class="doctor-avatar-wrap">
                            <img src="<%= photoUrl %>" alt="Dr. <%= docName %>" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <span style="display:none; width:100%; height:100%; align-items:center; justify-content:center;"><%= initial %></span>
                        </div>
                    </div>

                    <div class="doctor-card-body">
                        <h3>Dr. <%= docName %></h3>
                        <span class="doctor-spec-tag"><%= spec %></span>

                        <div class="doctor-meta-row">
                            <span><i class="bi bi-shield-check" style="color:var(--brand-teal);"></i> <strong>Verified Specialist</strong></span>
                            <span><i class="bi bi-star-fill" style="color:#f59e0b;"></i> 4.9 (140+ reviews)</span>
                        </div>

                        <p class="doctor-short-bio">
                            Dedicated to excellence in <%= spec.toLowerCase() %>, providing gentle, precision clinical care for patients of all ages.
                        </p>

                        <button type="button" class="btn-view-doc-bio">
                            <i class="bi bi-card-text"></i> View Profile & Description
                        </button>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <!-- FALLBACK SPECIALISTS WHEN DB HAS INITIAL DATA -->
                <div class="doctor-card" data-category="orthodontics" onclick="openDoctorModal('Amila Perera', 'Consultant Orthodontist & Smile Architect', '', '+1 (800) 555-0199', 'amila@sunrisedental.com', 'Dr. Amila Perera is a premier Consultant Orthodontist with over 12 years of specialized experience in clear aligners, Invisalign, and complex bite corrections. Known for crafting harmonious smile aesthetics, Dr. Perera combines 3D digital smile simulation with compassionate patient guidance.', 'A', 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80')">
                    <div class="doctor-card-banner">
                        <span class="doctor-badge-status"><i class="bi bi-circle-fill" style="color:#4ade80; font-size:8px;"></i> Available</span>
                        <div class="doctor-avatar-wrap">
                            <img src="https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80" alt="Dr. Amila Perera" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <span style="display:none; width:100%; height:100%; align-items:center; justify-content:center;">A</span>
                        </div>
                    </div>
                    <div class="doctor-card-body">
                        <h3>Dr. Amila Perera</h3>
                        <span class="doctor-spec-tag">Consultant Orthodontist</span>
                        <div class="doctor-meta-row">
                            <span><i class="bi bi-shield-check" style="color:var(--brand-teal);"></i> <strong>Verified Specialist</strong></span>
                            <span><i class="bi bi-star-fill" style="color:#f59e0b;"></i> 4.9 (180+ reviews)</span>
                        </div>
                        <p class="doctor-short-bio">Certified Invisalign provider specializing in modern Damon braces and orthodontic aesthetics.</p>
                        <button type="button" class="btn-view-doc-bio"><i class="bi bi-card-text"></i> View Profile & Description</button>
                    </div>
                </div>

                <div class="doctor-card" data-category="surgery" onclick="openDoctorModal('Kasun Silva', 'Senior Oral & Maxillofacial Surgeon', '', '+1 (800) 555-0199', 'kasun@sunrisedental.com', 'Dr. Kasun Silva is an esteemed Oral & Maxillofacial Surgeon specialized in dental implants, bone grafting, and gentle surgical extractions. He emphasizes zero-anxiety procedures utilizing cutting-edge computer-guided implantology.', 'K', 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80')">
                    <div class="doctor-card-banner">
                        <span class="doctor-badge-status"><i class="bi bi-circle-fill" style="color:#4ade80; font-size:8px;"></i> Available</span>
                        <div class="doctor-avatar-wrap">
                            <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80" alt="Dr. Kasun Silva" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <span style="display:none; width:100%; height:100%; align-items:center; justify-content:center;">K</span>
                        </div>
                    </div>
                    <div class="doctor-card-body">
                        <h3>Dr. Kasun Silva</h3>
                        <span class="doctor-spec-tag">Dental Surgeon & Implantologist</span>
                        <div class="doctor-meta-row">
                            <span><i class="bi bi-shield-check" style="color:var(--brand-teal);"></i> <strong>Verified Specialist</strong></span>
                            <span><i class="bi bi-star-fill" style="color:#f59e0b;"></i> 5.0 (210+ reviews)</span>
                        </div>
                        <p class="doctor-short-bio">Expert in painless titanium dental implants and full-mouth cosmetic dental reconstruction.</p>
                        <button type="button" class="btn-view-doc-bio"><i class="bi bi-card-text"></i> View Profile & Description</button>
                    </div>
                </div>

                <div class="doctor-card" data-category="cosmetic" onclick="openDoctorModal('Sanduni Fernando', 'Cosmetic & Aesthetic Dental Specialist', '', '+1 (800) 555-0199', 'sanduni@sunrisedental.com', 'Dr. Sanduni Fernando brings an artistic passion to cosmetic dentistry, specializing in porcelain veneers, laser teeth whitening, and composite bonding. Her personalized smile makeovers are celebrated for their natural brilliance.', 'S', 'https://images.unsplash.com/photo-1594824813590-389602e1c981?w=400&auto=format&fit=crop&q=80')">
                    <div class="doctor-card-banner">
                        <span class="doctor-badge-status"><i class="bi bi-circle-fill" style="color:#4ade80; font-size:8px;"></i> Available</span>
                        <div class="doctor-avatar-wrap">
                            <img src="https://images.unsplash.com/photo-1594824813590-389602e1c981?w=400&auto=format&fit=crop&q=80" alt="Dr. Sanduni Fernando" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <span style="display:none; width:100%; height:100%; align-items:center; justify-content:center;">S</span>
                        </div>
                    </div>
                    <div class="doctor-card-body">
                        <h3>Dr. Sanduni Fernando</h3>
                        <span class="doctor-spec-tag">Cosmetic Dental Surgeon</span>
                        <div class="doctor-meta-row">
                            <span><i class="bi bi-shield-check" style="color:var(--brand-teal);"></i> <strong>Verified Specialist</strong></span>
                            <span><i class="bi bi-star-fill" style="color:#f59e0b;"></i> 4.9 (160+ reviews)</span>
                        </div>
                        <p class="doctor-short-bio">Passionate about porcelain veneers, professional laser whitening, and confidence makeovers.</p>
                        <button type="button" class="btn-view-doc-bio"><i class="bi bi-card-text"></i> View Profile & Description</button>
                    </div>
                </div>
                <% } %>
            </div>
        </section>

        <!-- ========================================================= -->
        <!-- DOCTOR DETAIL INTERACTIVE MODAL -->
        <!-- ========================================================= -->
        <div class="doctor-modal-overlay" id="doctorModal" onclick="closeDoctorModalOnOverlay(event)">
            <div class="doctor-modal-box">
                <div class="modal-banner">
                    <button type="button" class="modal-close-btn" onclick="closeDoctorModal()">✕</button>
                    <span style="font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:#d6f4f8;">Doctor Clinical Profile</span>
                </div>

                <div class="modal-body-scroll">
                    <div class="modal-profile-header">
                        <div class="modal-avatar-lg">
                            <img id="modalDocPhoto" src="" alt="Doctor Photo" onerror="this.style.display='none'; document.getElementById('modalDocInitial').style.display='flex';">
                            <span id="modalDocInitial" style="display:none; width:100%; height:100%; align-items:center; justify-content:center; font-size:36px; font-weight:800; color:var(--brand-teal);">D</span>
                        </div>
                        <div>
                            <h2 style="margin:0; font-size:22px; font-weight:700; color:var(--brand-navy);" id="modalDocName">Dr. Specialist</h2>
                            <span style="color:var(--brand-teal); font-size:13.5px; font-weight:600;" id="modalDocSpec">Specialist</span>
                        </div>
                    </div>

                    <h4 style="margin:0 0 6px; font-size:14px; font-weight:700; color:var(--brand-navy);"><i class="bi bi-person-lines-fill" style="color:var(--brand-teal);"></i> Biography & Clinical Expertise</h4>
                    <p class="modal-bio-para" id="modalDocBio">
                        Detailed professional biography will load here.
                    </p>

                    <div class="modal-info-grid">
                        
                        <div class="modal-info-box">
                            <span><i class="bi bi-shield-check" style="color:var(--brand-teal);"></i> Status</span>
                            <strong style="color:#16a34a;"><i class="bi bi-check-circle-fill"></i> Active & Accepting Patients</strong>
                        </div>
                        <div class="modal-info-box">
                            <span><i class="bi bi-telephone-fill" style="color:var(--brand-teal);"></i> Direct Line</span>
                            <strong id="modalDocPhone">+1 (800) 555-0199</strong>
                        </div>
                        <div class="modal-info-box">
                            <span><i class="bi bi-envelope-at-fill" style="color:var(--brand-teal);"></i> Consultation Email</span>
                            <strong id="modalDocEmail">hello@sunrisedental.com</strong>
                        </div>
                    </div>

                    <a href="tel:+18005550199" class="btn-modal-book-cta">
                        <i class="bi bi-telephone-fill"></i> Call Reception to Book (+1 800 555-0199)
                    </a>
                </div>
            </div>
        </div>

        <!-- ========================================================= -->
        <!-- GALLERY & RESULTS -->
        <!-- ========================================================= -->
        <section id="gallery" class="gallery-section" data-aos="fade-up" data-aos-duration="900">
            <div class="gallery-grid">
                <div class="section-kicker" style="color:#dfeefb;">Smile Transformations</div>
                <h2 class="section-title" style="color:#eff7ff; margin-bottom:0;">Real Smiles. Real Results.</h2>

                <div class="gallery-cards">
                    <div class="gallery-card" data-aos="fade-right" data-aos-delay="100">
                        <div class="brand-badge"><span class="mini-mark"></span>PureSmile Aesthetic</div>
                    </div>
                    <div class="gallery-card" data-aos="fade-up" data-aos-delay="150"></div>
                    <div class="gallery-card" data-aos="fade-left" data-aos-delay="200"></div>
                </div>
            </div>

            <div class="callout">
                <div class="callout-copy" data-aos="fade-right" data-aos-duration="900">
                    <div class="icon-wrap">✦</div>
                    <h2>Your Smile,<br />Our Passion.</h2>
                    <p>
                        Schedule a gentle consultation with our specialists today and take the first step towards your dream smile.
                    </p>
                    <a href="#contact" class="callout-badge" style="text-decoration:none;">Contact Our Clinic →</a>
                </div>

                <div class="callout-visual" aria-label="Dental care banner" data-aos="fade-left" data-aos-duration="1000"></div>
            </div>
        </section>

        <!-- ========================================================= -->
        <!-- CONTACT & APPOINTMENT BOOKING HUB -->
        <!-- ========================================================= -->
        <section id="contact" class="contact-section" data-aos="fade-up" data-aos-duration="800">
            <div class="gallery-grid" style="padding-bottom: 40px;">
                <div class="section-kicker">Book Your Visit</div>
                <h2 class="section-title">Contact Us for Appointments</h2>

                <!-- CALL-TO-BOOK HERO BANNER -->
                <div class="call-to-book-banner" data-aos="zoom-in" data-aos-duration="800">
                    <div class="booking-notice-icon">
                        <i class="bi bi-telephone-inbound-fill"></i>
                    </div>
                    <div class="booking-notice-content">
                        <span class="booking-badge"><i class="bi bi-info-circle-fill"></i> PHONE & DIRECT APPOINTMENT BOOKINGS ONLY</span>
                        <h2>Please Call Our Reception to Book Your Appointment</h2>
                        <p>
                            To ensure optimal doctor availability, personalized consultation time, and immediate slot confirmation, <strong>all patient appointments are arranged directly with our friendly reception desk coordinators</strong>. We will check real-time doctor schedules and book your preferred date & time immediately.
                        </p>
                        <div class="quick-call-actions">
                            <a href="tel:+18005550199" class="call-action-btn primary"><i class="bi bi-telephone-fill"></i> Call Reception: +1 (800) 555-0199</a>
                            <a href="https://wa.me/18005550199" target="_blank" class="call-action-btn whatsapp"><i class="bi bi-whatsapp"></i> WhatsApp Booking</a>
                            <a href="mailto:appointments@sunrisedental.com" class="call-action-btn outline"><i class="bi bi-envelope-fill"></i> Email Inquiry</a>
                        </div>
                    </div>
                </div>

                <!-- 4 CONTACT INFORMATION CARDS -->
                <div class="services-grid">
                    <article class="service-card" data-aos="zoom-in" data-aos-delay="50">
                        <div class="service-icon">☎</div>
                        <h3>Phone Hotlines</h3>
                        <p><strong>+1 (800) 555-0199</strong></p>
                        <p class="contact-detail" style="margin-top:6px; color:#0ea5b4; font-weight:600;">Main Reception Desk</p>
                        <p class="contact-detail">24/7 Dental Emergency: +1 (800) 555-0911</p>
                    </article>

                    <article class="service-card" data-aos="zoom-in" data-aos-delay="100">
                        <div class="service-icon">✉</div>
                        <h3>Email Helpdesk</h3>
                        <p><strong>appointments@sunrisedental.com</strong></p>
                        <p class="contact-detail" style="margin-top:6px; color:#0ea5b4; font-weight:600;">Booking Inquiries</p>
                        <p class="contact-detail">General: hello@sunrisedental.com</p>
                    </article>

                    <article class="service-card" data-aos="zoom-in" data-aos-delay="150">
                        <div class="service-icon">📍</div>
                        <h3>Clinic Location</h3>
                        <p><strong>24 Harbor Avenue, Suite 4</strong></p>
                        <p class="contact-detail" style="margin-top:6px; color:#0ea5b4; font-weight:600;">Colombo 03, Dental Pavilion</p>
                        <p class="contact-detail">Reserved Free Patient Parking & Wheelchair Access</p>
                    </article>

                    <article class="service-card" data-aos="zoom-in" data-aos-delay="200">
                        <div class="service-icon">⏰</div>
                        <h3>Reception Hours</h3>
                        <p><strong>Mon - Sat: 9:00 AM - 7:00 PM</strong></p>
                        <p class="contact-detail" style="margin-top:6px; color:#0ea5b4; font-weight:600;">Sunday: 10:00 AM - 4:00 PM</p>
                        <p class="contact-detail">24/7 On-Call Emergency Toothache Care</p>
                    </article>
                </div>

                <!-- 3 SIMPLE STEPS TO BOOK -->
                <div class="booking-steps-grid" data-aos="fade-up" data-aos-delay="100">
                    <div class="booking-step-card">
                        <div class="step-num">1</div>
                        <div class="step-body">
                            <h4>Call Our Reception</h4>
                            <p>Dial our primary booking hotline at <strong>+1 (800) 555-0199</strong> or message us via WhatsApp.</p>
                        </div>
                    </div>
                    <div class="booking-step-card">
                        <div class="step-num">2</div>
                        <div class="step-body">
                            <h4>Select Doctor & Slot</h4>
                            <p>Our receptionist will check real-time availability and reserve the ideal specialist for your treatment.</p>
                        </div>
                    </div>
                    <div class="booking-step-card">
                        <div class="step-num">3</div>
                        <div class="step-body">
                            <h4>Instant Confirmation</h4>
                            <p>Receive immediate SMS and email confirmation with visit reminders and clinic directions.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <div class="footer-brand">
                    <img src="<%= contextPath %>/images/logo1.png" alt="Sunrise Dental Clinic" class="footer-logo">
                    <h4>Sunrise Dental Clinic</h4>
                    <p>Leading the way in advanced, gentle, and aesthetic dental solutions for patients of all generations.</p>
                </div>
            </div>

            <div class="footer-section">
                <h5>Quick Navigation</h5>
                <ul class="footer-links">
                    <li><a href="#home">Home</a></li>
                    <li><a href="#about">About Our Clinic</a></li>
                    <li><a href="#doctors">Specialist Doctors</a></li>
                    <li><a href="#services">Services & Fees</a></li>
                    <li><a href="#gallery">Smile Results</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h5>Specialized Care</h5>
                <ul class="footer-links">
                    <li><a href="#services">Clear Aligners & Braces</a></li>
                    <li><a href="#services">Dental Implants</a></li>
                    <li><a href="#services">Cosmetic Veneers</a></li>
                    <li><a href="#services">Laser Whitening</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h5>Emergency & Contact</h5>
                <ul class="footer-contact">
                    <li>📞 +1 (800) 555-0199</li>
                    <li>✉ hello@sunrisedental.com</li>
                    <li>📍 24 Harbor Avenue, Dental Suite 4</li>
                    <li>⏰ Mon-Sat: 9:00 AM - 7:00 PM</li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 Sunrise Dental Clinic System. All rights reserved.</p>
            <div class="footer-socials">
                <a href="<%= contextPath %>/login.jsp" class="social-link" title="Staff Login"><i class="bi bi-person-lock"></i> Staff Portal</a>
            </div>
        </div>
    </footer>

    <!-- AOS Script -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            once: true,
            offset: 40,
        });

        // Hide loader after animation
        window.addEventListener('load', () => {
            const loader = document.getElementById('intro-loader');
            if (loader) {
                setTimeout(() => {
                    loader.style.opacity = '0';
                    loader.style.transition = 'opacity 0.6s ease';
                    setTimeout(() => { loader.style.display = 'none'; }, 600);
                }, 800);
            }
        });

        // DOCTORS FILTERING LOGIC
        function filterDoctors(category, btnElement) {
            const buttons = document.querySelectorAll('.doctor-filter-btn');
            buttons.forEach(b => b.classList.remove('active'));
            if (btnElement) btnElement.classList.add('active');

            const cards = document.querySelectorAll('.doctor-card');
            cards.forEach(card => {
                const cardCat = card.getAttribute('data-category');
                if (category === 'all' || cardCat === category) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // DOCTOR MODAL LOGIC
        let currentSelectedDoctorName = "";

        function openDoctorModal(name, spec, room, phone, email, bio, initial, photoUrl) {
            currentSelectedDoctorName = name;
            document.getElementById('modalDocName').textContent = "Dr. " + name;
            document.getElementById('modalDocSpec').textContent = spec;
            const roomEl = document.getElementById('modalDocRoom');
            if (roomEl) roomEl.textContent = room || "";
            document.getElementById('modalDocPhone').textContent = phone;
            document.getElementById('modalDocEmail').textContent = email;
            document.getElementById('modalDocBio').textContent = bio;

            const photoImg = document.getElementById('modalDocPhoto');
            const initSpan = document.getElementById('modalDocInitial');
            if (photoUrl && photoImg) {
                photoImg.src = photoUrl;
                photoImg.style.display = 'block';
                if (initSpan) initSpan.style.display = 'none';
            } else {
                if (photoImg) photoImg.style.display = 'none';
                if (initSpan) {
                    initSpan.textContent = initial || "D";
                    initSpan.style.display = 'flex';
                }
            }

            const modal = document.getElementById('doctorModal');
            modal.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeDoctorModal() {
            const modal = document.getElementById('doctorModal');
            modal.classList.remove('show');
            document.body.style.overflow = 'auto';
        }

        function closeDoctorModalOnOverlay(event) {
            if (event.target === document.getElementById('doctorModal')) {
                closeDoctorModal();
            }
        }

        // Mobile Menu Toggle
        const menuToggle = document.getElementById('menuToggle');
        const primaryMenu = document.getElementById('primaryMenu');
        if (menuToggle && primaryMenu) {
            menuToggle.addEventListener('click', () => {
                primaryMenu.classList.toggle('is-open');
                const isExpanded = primaryMenu.classList.contains('is-open');
                menuToggle.setAttribute('aria-expanded', isExpanded);
            });
        }
    </script>
</body>
</html>
