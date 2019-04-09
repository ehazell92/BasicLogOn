<%@ Page Language="VB" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Diagnostics.Process" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Data.Sql" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />

    <link rel="Shortcut Icon" type="image/x-icon" href="favicon.ico" />

    <script runat="server">        

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

            If Not IsPostBack Then
                statbox.Text = ""
            End If

        End Sub

        Sub logInn(sender As Object, ea As EventArgs)

            Try
                Dim tusr As String = ""
                Dim tsfe As String = ""
                Dim logConn As New SqlConnection("ConnectionStringHere")
                Dim logCmd As New SqlCommand With {.Connection = logConn}
                logConn.Open()
                tusr = creden.Text.Split(":")(0)
                tsfe = creden.Text.Split(":")(1)
                creden.Text = ""
                logCmd.CommandText = "SELECT * FROM People WHERE userName='" & tusr & "'"
                Dim logRdr As SqlDataReader = logCmd.ExecuteReader

                If logRdr.HasRows Then
                    While logRdr.Read
                        If (tsfe = logRdr.Item("wordSafe").ToString) Then
                            Session("loginTime") = DateTime.Now.ToString("MM/dd/yyy") & ";" & DateTime.Now.ToString("hh:mm:ss")
                            LIsafeword.Value = ""
                            tusr = ""
                            LIuserName.Value = ""
                            tsfe = ""
                            Response.Redirect("adCt.aspx")
                        Else
                            LIsafeLbl.Style.Add("color", "red")
                            LIsafeLbl.Style.Add("text-shadow", "2px 2px 2px black")
                            usSp.InnerText = "Password - Invalid!"
                            Exit Sub
                        End If
                    End While
                Else
                    LIuserLbl.Style.Add("color", "red")
                    LIuserLbl.Style.Add("text-shadow", "2px 2px 2px black")
                    usSp.InnerText = "Username - Invalid!"
                End If
                logRdr.Close()
            Catch ex As Exception
                Response.Write("<br/><br/><br/> Exception ENCOUNTERED: " & ex.ToString)
            End Try
        End Sub

    </script>


    <script src="../scripts/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.css" type="text/javascript"></script>
    <script src="../scripts/jquery.min.js" type="text/javascript"></script>
    <link href="../scripts/bootstrap.min.css" rel="Stylesheet" type="text/css" />
    <script src="../scripts/bootstrap.min.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(document).ready(function () {

            $(window).keydown(function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 9) {
                    if (document.getElementById('LIuserName').style.display === 'block') {
                        e.preventDefault();
                        $('#LIsafeLbl').click();
                    } else {
                        e.preventDefault();
                        $('#LIuserLbl').click();
                    }
                }
                if (code == 13) {
                    $('#divLIsubBttn').click();
                }
            });

        })

        function verifyLI() {
            var uName = $('#LIuserName').val();
            var uPass = $('#LIsafeword').val();
            if (uName.length < 1 || uName.length < 1) {
                if (uName.length < 1) {
                    $('#LIuserLbl').css("color", "red");
                }
                if (uPass.length < 1) {
                    $('#LIsafeLbl').css("color", "red");
                }
                return;
            }
            document.getElementById("creden").value = uName + ":" + uPass;
            $('#BttnLIsbmt').click();            
        }

        function aniHand(callr) {
            var laybell;
            var txt;
            var vis;
            var goods;
            if (callr == 'LIuserName' || callr == 'LIsafeword') {
                if (callr == 'LIuserName') { laybell = 'LIuserLbl'; } else { laybell = 'LIsafeLbl'; }    
                txt = callr;
                goods = $('#' + txt).val();
                if (goods.length > 1) { vis = 'none' } else { vis = 'LblVis'; }
            } else {
                if(callr == 'LIuserLbl') { txt = 'LIuserName'; } else { txt = 'LIsafeword'; }
                laybell = callr;
                vis = 'TxtVis';
            }            
            labelAnimate(laybell, txt, vis);
        }

        function labelAnimate(lbl, txtb, act) {
            lbl = $('#' + lbl);
            txtb = $('#' + txtb);
            if (act == 'TxtVis') {
                lbl.addClass('fadeOutUp');
                setTimeout(function () {
                    lbl.css('display', 'none').promise().done(function () {
                        txtb.css('display', 'block');
                        txtb.addClass('flipInX');
                        lbl.removeClass('fadeOutUp');                        
                    }).promise().done(function () {
                        txtb.focus().promise().done(function () {
                            if (txtb.is(':focus')) {
                            } else {
                                txtb.focus();
                            }
                        });
                    });
                }, 150);
            } else if (act == 'LblVis') {
                txtb.removeClass('flipInX');
                txtb.addClass('flipOutX');
                setTimeout(function () {
                    txtb.css('display', 'none').promise().done(function () {
                        lbl.css('display', 'block');
                        lbl.addClass('fadeInDown');
                        txtb.removeClass('flipOutX');
                        txtb.val('');
                    });                            
                }, 650);
                lbl.removeClass('fadeInDown');
            }
            
        }


    </script>

    <link href="css/animate.css" rel="Stylesheet" type="text/css" />
    <link href="css/animate.min.css" rel="Stylesheet" type="text/css" />
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }
        html {
            height: 100%;
        }
        body {
            background-position: top;
            background-position: bottom;
            height: 100%;
            min-height: 100%;
            min-width: 100%;
            padding: 0 0 0 0;
            margin: 0 0 0 0;
            background-color: #262626;
            background-image: url('images/city.jpg');
            background-repeat: no-repeat;
            background-size: cover;
        }
            @font-face {
                font-family: stenzy;
                font-weight: bold;
                src: url('fonts/A_Font_with_Serifs.ttf')
            }
        #dimJuan {
            background: black;
            opacity: 0.57;
            width:100%;
            height:100%;
            position:absolute;
        }
        #formJuan {
            height:100%;
        }
        ::-webkit-input-placeholder { /* WebKit, Blink, Edge */
                color: white;
            }
            :-moz-placeholder { /* Mozilla Firefox 4 to 18 */
               color: white;
               opacity:  1;
            }
            ::-moz-placeholder { /* Mozilla Firefox 19+ */
               color: white;
               opacity:  1;
            }
            :-ms-input-placeholder { /* Internet Explorer 10-11 */
               color: white;
            }

            #divLI {

                    position: absolute;
                    display: table;
                    background: linear-gradient(rgba(51, 102, 153, .95), rgba(128, 128, 128, .85));
                    width: 27%;
                    max-width: 27%;
                    height: 50%;
                    max-height: 50%;
                    left: 36.5%;
                    margin-top: 10%;
                    border-radius: 5px;

            }
            #divLI:hover {
                   background: linear-gradient(rgb(51, 102, 153), rgb(128, 128, 128));
            }
            @media only screen and ( min-width: 901px) and ( max-width: 1000px) {
                #divLI {
                    width: 35%;
                    left: 32.5%;
                    max-width: 35%;
                                        max-height: 40%;
                }
            }
            @media only screen and ( min-width: 801px) and ( max-width: 900px) {
                #divLI {
                    width: 40%;
                    left: 30%;
                    max-width: 40%;
                                        max-height: 40%;
                }
            }
            @media only screen and ( min-width: 701px) and ( max-width: 800px) {
                #divLI {
                    width: 45%;
                    left: 27.5%;
                    max-width: 45%;
                                        max-height: 40%;
                }
            }
            @media only screen and ( min-width: 601px) and ( max-width: 700px) {
                #divLI {
                    width: 50%;
                    left: 25%;
                    max-width: 50%;
                                        max-height: 40%;
                }
            }
            @media only screen and ( min-width: 501px) and ( max-width: 600px) {
                #divLI {
                    width: 60%;
                    left: 20%;
                    max-width: 60%;
                    max-height: 40%;
                }
            }
            @media only screen and ( min-width: 400px) and ( max-width: 500px) {
                #divLI {
                    width: 70%;
                    left: 15%;
                    max-width:70%;
                    border-radius: 5px;
                    max-height: 40%;
                }
            }
            @media only screen and (min-width: 100px) and (max-width: 399px){
                #divLI {
                    max-height: 25%
                }
            }
                #divLIObj {
                    width: 100%;
                    height:80%;
                    display: table-cell;
                    vertical-align: middle;

                }
                    .LIlbl {
                        width: 80%;
                        margin-left: 10%;
                        font-size: 40px;
                        color: white;                        
                        border-bottom: 2px solid white;
                        margin-bottom:10%;
                        cursor: text;
                        font-family: stenzy;
                    } 
                    .LIlbl:hover {
                        font-size:44px;
                    }
                    #divLIObj input {
                        width: 80%;
                        margin-left: 10%;
                        margin-right: 10%;
                        border-radius: 3px;
                        margin-bottom: 10%;
                        border: 1px inset white;
                        font-size: 40px;
                        font-family: stenzy;
                        display: none;
                        background-color: rgba(255,255,255, .3);
                        border: 0;
                        color: white;
                    }
                    .invis {
                        display:none;
                    }
                    #divLIsubBttn {
                        margin-top: 20%;
                        height: 13%;
                        width: 70%;
                        margin-left: 15%;
                        margin-right: 15%;
                        background: linear-gradient(to right, #40bfbf, #4db380);
                        text-align: center;
                        display:table;
                        box-shadow: 1.5px 2px 2px grey;
                        cursor: pointer;
                        overflow: hidden;
                        border-radius: 10px;
                    }
                    #divLIsubBttn:hover {
                        box-shadow: 1.5px 2px 2px black;
                        text-shadow: 1px 1px 1px black;
                        border-radius: 13px;
                    }
                    #divLIsubBttn div {
                        font-size: 40px;
                        font-family: stenzy;
                        /*text-shadow: 1px 1px 1px black;*/
                        color: white;  
                        display: table-cell;
                        vertical-align: middle; 
                        opacity: 0.75;
                        position: absolute;
                        z-index: 100;
                        left: 25%;
                        right: 25%;
                    }
                    #divLIsubBttn #arr {
                        z-index: 200;
                        height: 100%;
                        filter: invert(100%);
                        float: right;
                        padding-right: 3%;
                        opacity: 0.75;
                        max-height: 45px
                    }
    </style>

    <title>Logon</title>
</head>
<body>
    <form id="formJuan" runat="server">
        <div id="dimJuan" runat="server">
            <asp:TextBox ID="statbox" runat="server" CssClass="invis" style="width:100%;" />
            <asp:Button ID="BttnLIsbmt" CssClass="invis" OnClick="logInn" runat="server" />
            <asp:TextBox ID="creden" CssClass="invis" runat="server" />
        </div>
        <div id="divLI" runat="server">
            <div id="divLIObj" runat="server">                

                <div id="LIuserLbl" class="LIlbl animated" onclick="aniHand(this.id);" runat="server"><span runat="server" id="usSp" style="opacity: 0.70;">Username</span></div>
                <input type="text" tabindex="1" id="LIuserName" onblur="aniHand(this.id);" class="animated"  runat="server" placeholder="username" />
                <div id="LIsafeLbl" class="LIlbl animated" onclick="aniHand(this.id);" runat="server"><span runat="server" id="sfSp" style="opacity: 0.70;">Password</span></div>
                <input type="password" id="LIsafeword" onblur="aniHand(this.id);" class="animated" runat="server" placeholder="password" />

                <div id="divLIsubBttn" onclick="verifyLI();" onmouseover="$('#arr').toggleClass('invis'); $('#arr').toggleClass('bounceInLeft');" onmouseout="$('#arr').toggleClass('invis'); $('#arr').toggleClass('bounceInLeft');" runat="server">                    
                    <div>Log In</div>
                    <img id="arr" class="invis animated" alt="" src="images/arrow1.png" />                     
                </div>                
            </div>
        </div>       
    </form>
</body>
</html>