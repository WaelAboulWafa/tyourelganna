Imports System
Imports System.Data
Imports System.Data.SqlClient

Partial Class api
    Inherits System.Web.UI.Page

    Private Sub api_Load(sender As Object, e As EventArgs) Handles Me.Load


        Dim api_call As String
        api_call = ""



        If HttpContext.Current.Request.HttpMethod = "GET" Then
            api_call = HttpContext.Current.Request.QueryString("api_call")
        End If

        If HttpContext.Current.Request.HttpMethod = "POST" Then
            api_call = HttpContext.Current.Request.Form("api_call")
        End If


        If api_call = "updatenickname" Then
            Dim tel, nick As String
            tel = ""
            nick = ""
            If HttpContext.Current.Request.HttpMethod = "GET" Then
                tel = HttpContext.Current.Request.QueryString("tel")
                nick = HttpContext.Current.Request.QueryString("nick")
            End If
            If HttpContext.Current.Request.HttpMethod = "POST" Then
                tel = HttpContext.Current.Request.Form("tel")
                nick = HttpContext.Current.Request.Form("nick")
            End If

            updatenickname(tel, nick)
            Return
        End If



        If api_call = "updatenickname_control" Then
            Dim tel, nick As String
            tel = ""
            nick = ""
            If HttpContext.Current.Request.HttpMethod = "GET" Then
                tel = HttpContext.Current.Request.QueryString("tel")
                nick = HttpContext.Current.Request.QueryString("nick")
            End If
            If HttpContext.Current.Request.HttpMethod = "POST" Then
                tel = HttpContext.Current.Request.Form("tel")
                nick = HttpContext.Current.Request.Form("nick")
            End If

            updatenickname_control(tel, nick)
            Return
        End If



    End Sub


    Public Sub updatenickname_control(ByVal tel As String, ByVal nick As String)

        nick = nick.Replace(vbCr, "").Replace(vbLf, "").Replace("'", "").Trim()

        Dim message_response As String = "Error."


        Dim constr As String
        Try
            constr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings("constr").ConnectionString
            Dim con As New SqlConnection


            con = New SqlConnection()
            con.ConnectionString = constr
            con.Open()



            '''''''''''''check if there is no nick name
            Dim cmd1 As New SqlCommand
            cmd1.Connection = con
            Dim havenick As Integer = 0
            cmd1.CommandText = "select count(1) as thecnt from ControlNicks where MSISDN_ID= @tel"
            Dim dr As SqlDataReader
            cmd1.Prepare()
            cmd1.Parameters.AddWithValue("@tel", tel)
            dr = cmd1.ExecuteReader
            If dr.HasRows Then
                While dr.Read()
                    havenick = dr("thecnt")
                End While
            End If
            dr.Close()

            Dim cmd As New SqlCommand
            cmd.Connection = con
            If havenick = 1 Then
                cmd.CommandText = "update ControlNicks set nickname= @nick where MSISDN_ID= @tel"
                cmd.Parameters.Add("@nick", SqlDbType.NVarChar).Value = nick
                cmd.Parameters.Add("@tel", SqlDbType.NVarChar).Value = tel
                cmd.ExecuteNonQuery()

                Dim cmd2 As New SqlCommand
                cmd2.Connection = con
                cmd2.CommandText = "update chatNickNames set MessageContents= @nick where MSISDN= @tel"
                cmd2.Parameters.Add("@nick", SqlDbType.NVarChar).Value = nick
                cmd2.Parameters.Add("@tel", SqlDbType.NVarChar).Value = tel
                cmd2.ExecuteNonQuery()

                message_response = "OK"
            Else
                message_response = "Not found"

            End If






        Catch ex As System.Exception
            message_response = ex.ToString
        End Try




        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "text/html;  encoding=utf-8;"
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*")
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS")
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Content-Range, Content-Disposition, Content-Description")
        HttpContext.Current.Response.AddHeader("Access-Control-Max-Age", "1728000")
        HttpContext.Current.Response.ContentEncoding = Encoding.Unicode
        Dim buffer = Encoding.UTF8.GetBytes(message_response)
        HttpContext.Current.Response.OutputStream.Write(buffer, 0, buffer.Length)
        HttpContext.Current.Response.Flush()
        HttpContext.Current.Response.End()
        HttpContext.Current.Response.Close()


    End Sub



    Public Sub updatenickname(ByVal tel As String, ByVal nick As String)

        nick = nick.Replace(vbCr, "").Replace(vbLf, "").Replace("'", "").Trim()

        Dim message_response As String = "Error."


        Dim constr As String
        Try
            constr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings("constr").ConnectionString
            Dim con As New SqlConnection


            con = New SqlConnection()
            con.ConnectionString = constr
            con.Open()



            '''''''''''''check if there is no nick name
            Dim cmd1 As New SqlCommand
            cmd1.Connection = con
            Dim havenick As Integer = 0
            cmd1.CommandText = "select count(1) as thecnt from chatNickNames where msisdn= @tel"
            Dim dr As SqlDataReader
            cmd1.Prepare()
            cmd1.Parameters.AddWithValue("@tel", tel)
            dr = cmd1.ExecuteReader
            If dr.HasRows Then
                While dr.Read()
                    havenick = dr("thecnt")
                End While
            End If
            dr.Close()

            Dim cmd As New SqlCommand
            cmd.Connection = con
            If havenick = 0 Then
                cmd.CommandText = "insert into chatNickNames (originalid,MSISDN,MessageContents) values (0,@tel,@nick)"
                cmd.Parameters.Add("@nick", SqlDbType.NVarChar).Value = nick
                cmd.Parameters.Add("@tel", SqlDbType.NVarChar).Value = tel
                cmd.ExecuteNonQuery()
            Else
                cmd.CommandText = "update chatNickNames set messagecontents= @nick where msisdn= @tel"
                cmd.Parameters.Add("@nick", SqlDbType.NVarChar).Value = nick
                cmd.Parameters.Add("@tel", SqlDbType.NVarChar).Value = tel
                cmd.ExecuteNonQuery()
            End If



            message_response = "OK"


        Catch ex As System.Exception
            message_response = ex.ToString
        End Try




        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "text/html;  encoding=utf-8;"
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*")
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS")
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Content-Range, Content-Disposition, Content-Description")
        HttpContext.Current.Response.AddHeader("Access-Control-Max-Age", "1728000")
        HttpContext.Current.Response.ContentEncoding = Encoding.Unicode
        Dim buffer = Encoding.UTF8.GetBytes(message_response)
        HttpContext.Current.Response.OutputStream.Write(buffer, 0, buffer.Length)
        HttpContext.Current.Response.Flush()
        HttpContext.Current.Response.End()
        HttpContext.Current.Response.Close()


    End Sub

End Class
