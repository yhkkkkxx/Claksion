<%--
  Created by IntelliJ IDEA.
  User: hayoung
  Date: 2024/04/30
  Time: 3:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

<!-- Core CSS -->
<link rel="stylesheet" href="../assets/vendor/css/core.css" class="template-customizer-core-css"/>
<link rel="stylesheet" href="../assets/vendor/css/theme-default.css" class="template-customizer-theme-css"/>
<link rel="stylesheet" href="../assets/css/demo.css"/>

<!-- build:js assets/vendor/js/core.js -->
<script src="../assets/vendor/libs/jquery/jquery.js"></script>
<script src="../assets/vendor/libs/popper/popper.js"></script>
<script src="../assets/vendor/js/bootstrap.js"></script>
<script src="../assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

<script>
    let poll_form = {
        init: function() {}
    };
    $(function () {
        poll_form.init();
    });

    function btn_poll() {
        let contents = $('.content');
        let poll_contents = Array.from(contents).map(c => ({
            "id": c.id,
            "pollId": ${poll.id},
            "name": c.name,
            "numOfVote": c.value,
            "selected": c.checked
        }));

        const pollId = ${poll.id};
        $.ajax({
            url:'<c:url value="/poll/formimpl"/>',
            type:'post',
            contentType:'application/json',
            data: JSON.stringify(poll_contents),
            success: () => {
                location.href="<c:url value="/poll/result"/>?pollId="+pollId;
            }
        });

    }
</script>

<%--<div class="row">--%>

<h1>투표</h1>
<div class="card mb-4">
    <div class="card-body">
        <div class="col-lg-12 mb-1 order-0">
            <div class="mb-3 col-md-6">
                <h3 for="title" class="form-label">제목</h3>
                <h1 class="mb-0"><small class="text-muted">${poll.title}</small></h1>
            </div>

        </div>
    </div>

    <hr class="m-0"><br/>


            <div class="card-body">
                <div class="row gy-3">
                    <div class="col-md">
                        <div class="mb-3">

                            <small class="text-light fw-semibold">
                                <c:choose>
                                    <c:when test="${poll.anonymity == false}">유기명 / </c:when>
                                    <c:otherwise>무기명 / </c:otherwise>
                                </c:choose>
                            </small>
                            <small class="text-light fw-semibold">
                                <c:choose>
                                    <c:when test="${poll.selectType == 'SINGLE'}">단일 선택</c:when>
                                    <c:otherwise>다중 선택</c:otherwise>
                                </c:choose>
                            </small>
                        </div>

                        <form id="contents">
                            <c:forEach var="p" items="${pollContents}">
                                <div class="form-check">
                                    <input
                                            name="${p.name}"
                                            class="form-check-input content"
                                            type="radio"
                                            value="${p.numOfVote}"
                                            id="${p.id}"
                                            <c:if test="${p.selected == true}">checked</c:if>
                                    />
                                    <label class="form-check-label" for="${p.id}">${p.name}</label>
                                </div>
                            </c:forEach>
                        </form>
                    </div>
                </div>
            </div>

    <br/><hr class="m-0"><br/>



    <div class="card-body">
        <div class="mb-3 col-md-6">
            <h3 for="title" class="form-label">마감</h3>
            <h5 class="mb-0"><small class="text-muted">${poll.deadline}</small></h5>
        </div>
    </div>

            <hr class="m-0"><br/>

    <button type="button" class="btn btn-primary" onclick="btn_poll()">투표</button>
        </div>


    </div>
</div>