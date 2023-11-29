
// department search function
function departmentSearch(x){
    var str = x.split(" ");
    if (/\s/.test(str)) {
        var x = str[1] + '%' + str[0]
    }
    $.ajax({
        type: 'GET',
        dataType: 'json',
        url: "assets/CFCs/functions.cfc",
        data: {
            method: "searchDepartment",
            searchStr: x
        },
        beforeSend: function() {
            $('#searchingDept').html(' <span style="color: rgb(59, 91, 152)"><i class="fad fa-spinner fa-pulse"></i></span>');
        },
        success: function(response) {
            var x = response.items;
            var str = '<div class="list-group">';
            for (var i = 0; i < x.length; i++) {
                str += '<a href="#"  class="list-group-item list-group-item-action" id="searchDeptResults_' + x[i].orgcode + '" orgcode="' + x[i].orgcode + '" display = "' + x[i].orgname + '">(' + x[i].orgcode + ') <span style="color:royalblue; font-weight:bold">' + x[i].orgname + '</span></a>';
            }
            str += '</div>';
            $('#deptResults').css({'z-index':'100000','overflow-y':'scroll'}).html(str).show();
            $("a[id^='searchDeptResults_'").on('click', function() {
                var orgcode = $(this).attr('orgcode');
                var orgname = $(this).attr('orgname');
                $('#DEPTID').val(orgcode).removeClass('placeholder');
                $('#DEPTNAME').val(orgname).removeClass('placeholder');
                $('#deptResults').hide();
            });
        },
        complete: function() {
            $('#searchingDept').html('');
        }
    });
}
//Employee search function
function employeeSearch(x) {
    var str = x.split(" ");
    if (/\s/.test(str)) {
        var x = str[1] + '%' + str[0]
    }
    $.ajax({
        type: 'GET',
        dataType: 'json',
        url: "assets/CFCs/functions.cfc",
        data: {
            method: "searchEmployees",
            searchStr: x
        },
        beforeSend: function() {
            $('#searching').html('<span style="color: rgb(59, 91, 152)"><i class="fas fa-spinner fa-spin"></i></span>');
        },
        success: function(response) {
            var x = response.items;
            var str = '<div class="list-group">';
            for (var i = 0; i < x.length; i++) {
                str += '<a href="#"  class="list-group-item list-group-item-action" id="searchResults_' + x[i].emplID + '" phone ="' + x[i].phone + '" location ="' + x[i].location + '" jobTitle ="' + x[i].jobTitle + '" departmentname ="' + x[i].departmentname + '"  username ="' + x[i].username + '" orgcode="' + x[i].orgcode + '" email="' + x[i].email + '" fullName="' + x[i].fullName + '" emplid="' + x[i].emplID + '" display = "' + x[i].fullName + '">(' + x[i].emplID + ') <span style="color:royalblue; font-weight:bold">' + x[i].fullName + '</span> <span style="color:orange">'+x[i].departmentname+'</span></a>';
            }
            str += '</div>';
            $('#results').css({'z-index':'100000','overflow-y':'scroll'}).html(str).show();
            
            $("a[id^='searchResults_'").on('click', function() {
                var disName = $(this).attr('display');
                var email = $(this).attr('email');
                var orgcode = $(this).attr('orgcode');
                var userid = $(this).attr('username');
                var emplid = $(this).attr('emplid');
                var fullName = $(this).attr('fullName');
                var departmentname = $(this).attr('departmentname');
                var location = $(this).attr('location');
                var jobTitle = $(this).attr('jobTitle');
                var phone = $(this).attr('phone');

                $('#emplid').val(emplid).attr({
                    'EMPLID': emplid
                }).focus();
                $('#vendorname').val(fullName).removeClass('placeholder');
                $('#vendorID').val(emplid).removeClass('placeholder');
                $('#STEWARD_NAME').val(fullName).removeClass('placeholder');
                $('#EMPLID').html(' ('+emplid+')').removeClass('placeholder');
                $('#FULL_NAME').html(fullName).removeClass('placeholder').append(' <br> ');
                $('#JOBTITLE').html(jobTitle).removeClass('placeholder').append(' <br> ');
                $('#DEPARTMENT').html(departmentname +' ('+orgcode+')').removeClass('placeholder').append(' <br> ');
                $('#EMAIL_ADDRESS').html(email).removeClass('placeholder').append(' <br> ');
                $('#LOCATION').html(location).removeClass('placeholder').append(' - ');
                $('#PHONE').html(phone).removeClass('placeholder');
                $('#results').hide();
                
            });
        },
        complete: function() {
            $('#searching').html('');
        }
    })

}
function createFiscalYearDropdown(selector) {
    const fiscalYearDropdown = $(selector);
    const currentDate = moment();
    const fiscalYearStart = currentDate.clone().month('September').startOf('month');
    const fiscalYearEnd = currentDate.clone().month('August').endOf('month').add(1, 'year');
    const inCurrentFiscalYear = currentDate.isBetween(fiscalYearStart, fiscalYearEnd, undefined, '[]');
    if (!inCurrentFiscalYear) {
        fiscalYearStart.subtract(1, 'year');
        fiscalYearEnd.subtract(1, 'year');
    }

    const startYear = fiscalYearStart.year() - 4; // 4 years back
    
    for (let i = 0; i < 8; i++) { // 4 years back + current year + 3 years forward
        const year = startYear + i;
        const fiscalYearText = `${year}-${year + 1}`;
        const fiscalYearValue = `FY-${(year + 1).toString().slice(-2)}`;
        const option = $('<option>', { value: fiscalYearValue, text: fiscalYearText });
        fiscalYearDropdown.append(option);
    }
    fiscalYearDropdown.val(`FY-${fiscalYearEnd.year().toString().slice(-2)}`);
}


function upload() {
    var formData = new FormData();
    var totalFiles = document.getElementById("FileUpload").files.length;

    for (var i = 0; i < totalFiles; i++) {
        var file = document.getElementById("FileUpload").files[i];

        formData.append("FileUpload", file);
        formData.append("guid", theGuid);
    }

    $.ajax({
        type: 'POST',
        url: 'CFC/functions.cfc?method=uploadFile',
        data: formData,
        dataType: 'json',
        contentType: false,
        processData: false,
        success: function (response) {
            alert('succes!!');
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $('#response').html('Error uploading image: ' + textStatus);
        }
    });
}

function loadImages(){
    $.ajax({
      url: 'assets/CFCs/functions.cfc',
      type: 'GET',
      dataType: 'json',
      data: {
        method: 'getDirectoryContents',
        path: '../images/fellows/'
      },
      success: function(data) {
        //console.log(data);
        var images = data.items;
        for (var i = 0; i < images.length; i++) {
          var fullName = images[i].name.split(",")[0]
          var title = images[i].name.split(".jpg")[0].split(",")[1]
          
          var fellow = '';
            fellow += '<div class="col" style="max-width: 14rem;">';
            fellow += '<div class="card">';
            fellow += '<img src="assets/images/fellows/'+images[i].name+'" height="275" class="card-img-top" alt="'+images[i].name+'">';
            fellow += '<div class="card-body">';
            fellow += '<span class="card-text fw-bold" style="font-size:16px; margin-left:-10px; margin-right:15px">'+fullName+'<br><span class="fst-italic mt-0">'+ title +'</span> </span><a href="#'+images[i].emplid+'"><i class="fas fa-analytics float-end"></i></a>';
            fellow += '</div>';
            fellow += '</div>';
            fellow += '</div>';
            $('.fellows').append(fellow);
        }
        
      },
      error: function(xhr, status, error) {
        console.log(xhr);
        var error = '';
        error += '<div class="col" style="max-width: 14rem;">';
        error += '<div class="card">';
        error += '<img src="assets/images/fellows/'+images[i].name+'" height="275" class="card-img-top" alt="'+images[i].name+'">';
        error += '<div class="card-body">';
        error += '<span class="card-text fw-bold" style="font-size:16px; margin-left:-10px; margin-right:15px">'+fullName+'<br><span class="fst-italic mt-0">'+ title +'</span> </span>';
        error += '</div>';
        error += '</div>';
        error += '</div>';
        $('.fellows').append(error);
        
      }
    });
  }