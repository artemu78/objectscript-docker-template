Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="SourceDir" Value="#{$system.Process.CurrentDirectory()}src"/>
  <Default Name="Namespace" Value="IRISAPP"/>
  <Default Name="app" Value="irisapp" />

  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="no">

    <Configuration>
      <Database Name="${Namespace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${Namespace}"/>

      <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
    </Configuration>
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="64"
       
    />
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod RestWebApp() As %Status
{
  set namespace = $NAMESPACE
  zn "%SYS"
  write "Create web application ..."
  set webName = "/api"
  set webProperties("DispatchClass") = "Api.Rest"
  set webProperties("NameSpace") = "IRISAPP"
  set webProperties("Enabled") = 1
  set webProperties("AutheEnabled") = 64
  set webProperties("MatchRoles")=":%DB_IRISAPP"
  set sc = ##class(Security.Applications).Create(webName, .webProperties)
  write:'sc sc
  write:sc "Web application "_webName_" has been created!"
  zn namespace
}

ClassMethod ModifyIrisapp() As %Status
{
  set namespace = $NAMESPACE
  zn "%SYS"
  set webName = "/csp/irisapp"
  set webProperties("MatchRoles")=":%DB_IRISAPP"
  set sc = ##class(Security.Applications).Modify(webName, .webProperties)
  write:'sc sc
  write:sc "Web application "_webName_" has been modified!"
  zn namespace
}

}
