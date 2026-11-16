Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$installDir = "$env:USERPROFILE\Downloads\ErrorXTools"
$version = "1.0"

$nav = [ordered]@{
    "Library" = "All", "Installed", "Updates"
    "Sources" = "MeowTonynoh", "Orbdiff", "NirSoft", "p1aegg"
    "ErrorX"  = , "Checks"
    "System"  = , "Dependencies"
}

$tools = @(
    @{ Name="MeowResolver";       Owner="MeowTonynoh"; Type="Exe"; Admin=$true;  Desc="Finds and removes SS bypasses" }
    @{ Name="MeowModAnalyzer";    Owner="MeowTonynoh"; Type="Ps1"; Admin=$false; Desc="Mod analyzer" }
    @{ Name="MeowDoomsdayFucker"; Owner="MeowTonynoh"; Type="Exe"; Admin=$true;  Desc="Doomsday finder" }
    @{ Name="MeowClientFucker";   Owner="MeowTonynoh"; Type="Exe"; Admin=$true;  Desc="Cheat client scanner" }
    @{ Name="MeowImportsChecker"; Owner="MeowTonynoh"; Type="Exe"; Admin=$true;  Desc="File and imports checker" }
    @{ Name="PrefetchView";       Owner="Orbdiff"; Asset="pv++.exe";        Type="Exe"; Admin=$true; Desc="Prefetch parser" }
    @{ Name="BAMReveal";          Owner="Orbdiff";                          Type="Exe"; Admin=$true; Desc="BAM parser" }
    @{ Name="Fileless";           Owner="Orbdiff"; Asset="fileless.exe";    Type="Exe"; Admin=$true; Desc="Fileless execution detector" }
    @{ Name="DPS-Analyzer";       Owner="Orbdiff"; Asset="dpsanalyzer.exe"; Type="Exe"; Admin=$true; Desc="DPS memory strings" }
    @{ Name="JournalParser";      Owner="Orbdiff";                          Type="Exe"; Admin=$true; Desc="USN journal parser" }
    @{ Name="InjGen";             Owner="Orbdiff";                          Type="Exe"; Admin=$true; Desc="JNI / JVMTI injection detector" }
    @{ Name="USBDetector";        Owner="Orbdiff";                          Type="Exe"; Admin=$true; Desc="USB history" }
    @{ Name="JARParser";          Owner="Orbdiff";                          Type="Exe"; Admin=$true; Desc="Executed jar files" }
    @{ Name="JumpListsView";      Owner="NirSoft"; Type="Zip"; Admin=$false; Desc="Jump lists"
       Url="https://www.nirsoft.net/utils/jumplistsview.zip"; Page="https://www.nirsoft.net/utils/jump_lists_view.html" }
    @{ Name="ShellBagsView";      Owner="NirSoft"; Type="Zip"; Admin=$false; Desc="ShellBags"
       Url="https://www.nirsoft.net/utils/shellbagsview.zip"; Page="https://www.nirsoft.net/utils/shell_bags_view.html" }
    @{ Name="BrowserDownloadsView"; Owner="NirSoft"; Type="Zip"; Admin=$false; Desc="Browser downloads"
       Url="https://www.nirsoft.net/utils/browserdownloadsview-x64.zip"; Page="https://www.nirsoft.net/utils/web_browser_downloads_view.html" }
    @{ Name="NetworkUsageView";   Owner="NirSoft"; Type="Zip"; Admin=$true; Desc="Network usage per app"
       Url="https://www.nirsoft.net/utils/networkusageview-x64.zip"; Page="https://www.nirsoft.net/utils/network_usage_view.html" }
    @{ Name="FullEventLogView";   Owner="NirSoft"; Type="Zip"; Admin=$true; Desc="Event log viewer"
       Url="https://www.nirsoft.net/utils/fulleventlogview-x64.zip"; Page="https://www.nirsoft.net/utils/full_event_log_view.html" }
    @{ Name="ClassLoaderDump";    Owner="p1aegg";  Type="Ps1"; Admin=$true; Desc="Dumps loaded classes from javaw"
       Url="https://raw.githubusercontent.com/p1aegg/powershell/refs/heads/main/ClassLoaderDump.ps1"; Page="https://github.com/p1aegg/powershell" }
    @{ Name="ServiceCheck";       Owner="Checks";  Type="Ps1"; Admin=$false; Desc="SS services and start times"
       Url="https://raw.githubusercontent.com/Okolle7/ServiceChecker/main/ServiceCheck.ps1"; Page="https://github.com/Okolle7/ServiceChecker" }
    @{ Name="MacroCheck";         Owner="Checks";  Type="Ps1"; Admin=$true;  Desc="Macro detector"
       Url="https://raw.githubusercontent.com/Okolle7/MacroChecker/main/MacroCheck.ps1"; Page="https://github.com/Okolle7/MacroChecker" }
    @{ Name="JVM Argument";       Owner="Checks";  Type="Ps1"; Admin=$false; Desc="Minecraft JVM arguments"
       Url="https://raw.githubusercontent.com/Okolle7/JVM-Arguments/main/JVMArgument.ps1"; Page="https://github.com/Okolle7/JVM-Arguments" }
    @{ Name="NET 9.0";            Owner="Dependencies"; Type="Setup"; Admin=$false; Desc=".NET 9 Desktop Runtime"
       Url="https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/9.0.22/windowsdesktop-runtime-9.0.22-win-x64.exe"; Page="https://dotnet.microsoft.com/en-us/download/dotnet/9.0" }
    @{ Name="NET 10.0";           Owner="Dependencies"; Type="Setup"; Admin=$false; Desc=".NET 10 Desktop Runtime"
       Url="https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/10.0.14/windowsdesktop-runtime-10.0.14-win-x64.exe"; Page="https://dotnet.microsoft.com/en-us/download/dotnet/10.0" }
    @{ Name="VSRedist";           Owner="Dependencies"; Type="Setup"; Admin=$false; Desc="Visual C++ Redistributable"
       Url="https://aka.ms/vs/17/release/vc_redist.x64.exe"; Page="https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist" }
)

foreach ($t in $tools) {
    switch ($t.Type) {
        "Exe" {
            if (-not $t.Asset) { $t.Asset = "$($t.Name).exe" }
            $t.Url = "https://github.com/$($t.Owner)/$($t.Name)/releases/latest/download/$($t.Asset)"
            $t.Path = Join-Path $installDir "$($t.Name).exe"
            $t.Download = $t.Path
        }
        "Setup" {
            $t.Path = Join-Path $installDir "Dependencies\$($t.Name).exe"
            $t.Download = $t.Path
            $t.Meta = Join-Path $installDir "meta\$($t.Name).json"
        }
        "Zip" {
            $t.ExtractTo = Join-Path $installDir $t.Name
            $t.Path = Join-Path $t.ExtractTo "$($t.Name).exe"
            $t.Download = Join-Path $installDir "$($t.Name).zip"
            $t.Meta = Join-Path $installDir "meta\$($t.Name).json"
        }
        "Ps1" { if (-not $t.Url) { $t.Url = "https://raw.githubusercontent.com/$($t.Owner)/$($t.Name)/main/$($t.Name).ps1" } }
    }
    if (-not $t.Page) { $t.Page = "https://github.com/$($t.Owner)/$($t.Name)" }
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ErrorX Tools" Width="1040" Height="660" MinWidth="880" MinHeight="500"
        WindowStartupLocation="CenterScreen" Background="#18181B"
        FontFamily="Segoe UI Variable Text, Segoe UI" FontSize="12.5" Foreground="#A1A1AA" UseLayoutRounding="True">
    <Window.Resources>
        <Style x:Key="Button" TargetType="Button">
            <Setter Property="Foreground" Value="#E4E4E7"/>
            <Setter Property="Background" Value="#27272A"/>
            <Setter Property="BorderBrush" Value="#3F3F46"/>
            <Setter Property="Padding" Value="12,5"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="1" CornerRadius="5" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bd" Property="Opacity" Value="0.85"/></Trigger>
                            <Trigger Property="IsPressed" Value="True"><Setter TargetName="bd" Property="Opacity" Value="0.7"/></Trigger>
                            <Trigger Property="IsEnabled" Value="False"><Setter TargetName="bd" Property="Opacity" Value="0.4"/></Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="Primary" TargetType="Button" BasedOn="{StaticResource Button}">
            <Setter Property="Foreground" Value="#18181B"/>
            <Setter Property="Background" Value="#E4E4E7"/>
            <Setter Property="BorderBrush" Value="#E4E4E7"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
        </Style>
        <Style x:Key="Warn" TargetType="Button" BasedOn="{StaticResource Button}">
            <Setter Property="Foreground" Value="#E3B341"/>
            <Setter Property="Background" Value="#2B2410"/>
            <Setter Property="BorderBrush" Value="#5C4813"/>
        </Style>
        <Style x:Key="Link" TargetType="Button">
            <Setter Property="Foreground" Value="#A1A1AA"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bd" Background="Transparent" Padding="10,0">
                            <ContentPresenter VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True"><Setter Property="Foreground" Value="#E4E4E7"/></Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="Nav" TargetType="RadioButton">
            <Setter Property="GroupName" Value="nav"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Margin" Value="8,0,8,1"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="RadioButton">
                        <Border x:Name="bg" Background="Transparent" CornerRadius="5" Height="28">
                            <Grid>
                                <Border x:Name="bar" Width="3" Height="14" CornerRadius="1.5" HorizontalAlignment="Left" Background="Transparent"/>
                                <ContentPresenter Margin="12,0,10,0" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bg" Property="Background" Value="#1F1F23"/></Trigger>
                            <Trigger Property="IsChecked" Value="True">
                                <Setter TargetName="bg" Property="Background" Value="#27272A"/>
                                <Setter TargetName="bar" Property="Background" Value="#E5484D"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="ScrollBar">
            <Setter Property="Width" Value="10"/>
            <Setter Property="MinWidth" Value="0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ScrollBar">
                        <Track x:Name="PART_Track" IsDirectionReversed="True">
                            <Track.Thumb>
                                <Thumb>
                                    <Thumb.Template>
                                        <ControlTemplate TargetType="Thumb">
                                            <Border Background="#3F3F46" CornerRadius="3" Margin="2"/>
                                        </ControlTemplate>
                                    </Thumb.Template>
                                </Thumb>
                            </Track.Thumb>
                        </Track>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="ToolTip">
            <Setter Property="Background" Value="#27272A"/>
            <Setter Property="Foreground" Value="#E4E4E7"/>
            <Setter Property="BorderBrush" Value="#3F3F46"/>
        </Style>
    </Window.Resources>

    <DockPanel>
        <Border DockPanel.Dock="Bottom" Background="#131316" BorderBrush="#27272A" BorderThickness="0,1,0,0">
            <StackPanel>
                <TextBox x:Name="Log" Height="130" Visibility="Collapsed" IsReadOnly="True" TextWrapping="Wrap"
                         VerticalScrollBarVisibility="Auto" Background="#131316" Foreground="#A1A1AA" BorderThickness="0,0,0,1"
                         BorderBrush="#27272A" FontFamily="Cascadia Mono, Consolas" FontSize="11.5" Padding="12,8"/>
                <DockPanel Height="26" Margin="12,0,2,0">
                    <Button x:Name="BtnLog" DockPanel.Dock="Right" Style="{StaticResource Link}" Content="Log"/>
                    <StackPanel DockPanel.Dock="Right" Orientation="Horizontal" Margin="0,0,6,0">
                        <Ellipse x:Name="AdminDot" Width="6" Height="6" VerticalAlignment="Center"/>
                        <TextBlock x:Name="AdminText" Margin="6,0,0,0" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock x:Name="Status" VerticalAlignment="Center" TextTrimming="CharacterEllipsis"/>
                </DockPanel>
            </StackPanel>
        </Border>

        <Border DockPanel.Dock="Left" Width="200" Background="#131316" BorderBrush="#27272A" BorderThickness="0,0,1,0">
            <DockPanel>
                <StackPanel DockPanel.Dock="Top" Orientation="Horizontal" Margin="18,18,0,14">
                    <Border Width="24" Height="24" CornerRadius="5" Background="#E5484D">
                        <TextBlock Text="X" Foreground="White" FontWeight="Bold" FontSize="13" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>
                    <StackPanel Margin="10,0,0,0" VerticalAlignment="Center">
                        <TextBlock Text="ErrorX Tools" Foreground="#E4E4E7" FontSize="13.5" FontWeight="SemiBold"/>
                        <TextBlock x:Name="Version" Foreground="#71717A" FontSize="11"/>
                    </StackPanel>
                </StackPanel>
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel x:Name="Nav" Margin="0,0,0,12"/>
                </ScrollViewer>
            </DockPanel>
        </Border>

        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>

            <DockPanel Margin="24,18,24,16">
                <StackPanel DockPanel.Dock="Right" Orientation="Horizontal" VerticalAlignment="Center">
                    <Border Width="230" Height="30" Margin="0,0,8,0" CornerRadius="5" Background="#1F1F23" BorderBrush="#3F3F46" BorderThickness="1">
                        <Grid>
                            <TextBlock Text="&#xE721;" FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="11" Foreground="#71717A"
                                       Margin="10,0,0,0" VerticalAlignment="Center"/>
                            <TextBlock x:Name="SearchHint" Text="Search   Ctrl+F" Foreground="#71717A" Margin="30,0,0,0" VerticalAlignment="Center" IsHitTestVisible="False"/>
                            <TextBox x:Name="Search" Background="Transparent" BorderThickness="0" Foreground="#E4E4E7" CaretBrush="#E4E4E7"
                                     Margin="27,0,6,0" VerticalContentAlignment="Center"/>
                        </Grid>
                    </Border>
                    <Button x:Name="BtnFolder" Style="{StaticResource Button}" Content="Open folder" Margin="0,0,8,0"/>
                    <Button x:Name="BtnUpdateAll" Style="{StaticResource Warn}" Margin="0,0,8,0" Visibility="Collapsed"/>
                    <Button x:Name="BtnAll" Style="{StaticResource Primary}" Content="Download all"/>
                </StackPanel>
                <StackPanel VerticalAlignment="Center">
                    <TextBlock x:Name="Heading" Foreground="#E4E4E7" FontSize="18" FontWeight="SemiBold"
                               FontFamily="Segoe UI Variable Display, Segoe UI"/>
                    <TextBlock x:Name="SubHeading" Foreground="#71717A" FontSize="12" Margin="0,1,0,0"/>
                </StackPanel>
            </DockPanel>

            <Border Grid.Row="1" BorderBrush="#27272A" BorderThickness="0,1,0,1" Background="#1B1B1F" Padding="24,7,34,7">
                <Grid TextElement.Foreground="#71717A" TextElement.FontSize="11" TextElement.FontWeight="SemiBold">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="120"/>
                        <ColumnDefinition Width="70"/>
                        <ColumnDefinition Width="160"/>
                        <ColumnDefinition Width="176"/>
                    </Grid.ColumnDefinitions>
                    <TextBlock Text="NAME"/>
                    <TextBlock Grid.Column="1" Text="AUTHOR"/>
                    <TextBlock Grid.Column="2" Text="TYPE"/>
                    <TextBlock Grid.Column="3" Text="STATUS"/>
                </Grid>
            </Border>

            <Grid Grid.Row="2">
                <ScrollViewer VerticalScrollBarVisibility="Visible">
                    <StackPanel x:Name="Rows"/>
                </ScrollViewer>
                <TextBlock x:Name="Empty" Text="No tools found" Foreground="#71717A" HorizontalAlignment="Center" VerticalAlignment="Center" Visibility="Collapsed"/>
            </Grid>
        </Grid>
    </DockPanel>
</Window>
'@

$rowXaml = @'
<Border xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Background="Transparent" BorderBrush="#232327" BorderThickness="0,0,0,1" Padding="24,9,24,9">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="120"/>
            <ColumnDefinition Width="70"/>
            <ColumnDefinition Width="160"/>
            <ColumnDefinition Width="176"/>
        </Grid.ColumnDefinitions>
        <StackPanel VerticalAlignment="Center" Margin="0,0,12,0">
            <TextBlock Text="{NAME}" Foreground="#E4E4E7" FontSize="13" FontWeight="SemiBold" TextTrimming="CharacterEllipsis"/>
            <TextBlock Text="{DESC}" Foreground="#71717A" Margin="0,1,0,0" TextTrimming="CharacterEllipsis"/>
        </StackPanel>
        <TextBlock Grid.Column="1" Text="{AUTHOR}" VerticalAlignment="Center" TextTrimming="CharacterEllipsis"/>
        <StackPanel Grid.Column="2" VerticalAlignment="Center">
            <TextBlock Text="{TYPE}" FontFamily="Cascadia Mono, Consolas" FontSize="11.5"/>
            <TextBlock x:Name="Admin" Text="admin" Foreground="#D29922" FontSize="11" Margin="0,1,0,0"/>
        </StackPanel>
        <StackPanel Grid.Column="3" VerticalAlignment="Center">
            <TextBlock x:Name="State" Foreground="#A1A1AA"/>
            <StackPanel x:Name="CheckLine" Orientation="Horizontal" Margin="0,2,0,0" Visibility="Collapsed">
                <Ellipse x:Name="Dot" Width="6" Height="6" VerticalAlignment="Center"/>
                <TextBlock x:Name="Check" FontSize="11.5" Margin="6,0,0,0"/>
            </StackPanel>
            <ProgressBar x:Name="Busy" IsIndeterminate="True" Height="2" Width="100" HorizontalAlignment="Left" Margin="0,5,0,0"
                         Foreground="#E5484D" Background="#27272A" BorderThickness="0" Visibility="Collapsed"/>
        </StackPanel>
        <StackPanel Grid.Column="4" Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
            <Button x:Name="UpdateBtn" Content="Update" Width="80" Padding="8,4" Margin="0,0,8,0" Visibility="Collapsed"/>
            <Button x:Name="Btn" Width="88" Padding="8,4"/>
        </StackPanel>
    </Grid>
</Border>
'@

$navItemXaml = @'
<DockPanel xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation">
    <TextBlock DockPanel.Dock="Right" Foreground="#71717A" FontSize="11.5" VerticalAlignment="Center"/>
    <TextBlock Text="{NAME}" Foreground="#D4D4D8" VerticalAlignment="Center"/>
</DockPanel>
'@

$window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$ui = @{}
foreach ($name in "Nav", "Rows", "Empty", "Search", "SearchHint", "Heading", "SubHeading", "Log", "Status", "BtnLog",
                  "BtnAll", "BtnUpdateAll", "BtnFolder", "AdminDot", "AdminText", "Version") {
    $ui[$name] = $window.FindName($name)
}

if (-not ("ErrorX.Dwm" -as [type])) {
    Add-Type -Namespace ErrorX -Name Dwm -MemberDefinition '[DllImport("dwmapi.dll")] public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int value, int size);'
}
$window.Add_SourceInitialized({
    $hwnd = (New-Object Windows.Interop.WindowInteropHelper $window).Handle
    $dark = 1
    [void][ErrorX.Dwm]::DwmSetWindowAttribute($hwnd, 20, [ref]$dark, 4)
})

$colors = @{ Green = "#3FB950"; Amber = "#D29922"; Red = "#F85149"; Gray = "#71717A" }

function New-Brush($hex) { [Windows.Media.BrushConverter]::new().ConvertFromString($hex) }

function Write-Log($msg) {
    $ui.Log.AppendText("[$(Get-Date -Format HH:mm:ss)] $msg`r`n")
    $ui.Log.ScrollToEnd()
    $ui.Status.Text = $msg
}

function Start-Tool($tool) {
    $params = @{ FilePath = $tool.Path; ErrorAction = "Stop" }
    if ($tool.Type -eq "Ps1") {
        $params.FilePath = "powershell.exe"
        $params.ArgumentList = "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", "Invoke-Expression (Invoke-RestMethod '$($tool.Url)')"
    } else {
        $params.WorkingDirectory = Split-Path $tool.Path
    }
    if ($tool.Admin -and -not $isAdmin) { $params.Verb = "RunAs" }

    try {
        Start-Process @params
        Write-Log "Started $($tool.Name)"
    } catch {
        Write-Log "$($tool.Name): $($_.Exception.Message)"
    }
}

function Test-Installed($tool) { $tool.Type -ne "Ps1" -and (Test-Path $tool.Path) }

function Test-NeedsUpdate($tool) { $tool.Check.State -in "outdated", "modified", "unknown" -and (Test-Installed $tool) }

function Test-InView($tool, $view) {
    switch ($view) {
        "All"       { return $true }
        "Installed" { return Test-Installed $tool }
        "Updates"   { return Test-NeedsUpdate $tool }
        default     { return $tool.Owner -eq $view }
    }
}

function Update-Row($tool) {
    $installed = Test-Installed $tool
    $tool.Busy.Visibility = if ($tool.Downloading) { "Visible" } else { "Collapsed" }
    $tool.Btn.IsEnabled = -not $tool.Downloading

    if ($tool.Downloading) {
        $tool.State.Text = "Downloading"
    } elseif ($tool.Type -eq "Ps1") {
        $tool.State.Text = "Online"
        $tool.Btn.Content = "Run"
    } elseif ($installed) {
        $size = (Get-Item $tool.Path).Length
        $tool.State.Text = if ($size -lt 1MB) { "{0:N0} KB" -f ($size / 1KB) } else { "{0:N1} MB" -f ($size / 1MB) }
        $tool.Btn.Content = if ($tool.Type -eq "Setup") { "Install" } else { "Run" }
    } else {
        $tool.State.Text = "Not downloaded"
        $tool.Btn.Content = "Download"
    }

    $check = $tool.Check
    $text = $null
    $color = $colors.Gray
    if ($installed -and -not $tool.Downloading) {
        if ($tool.Verifying) {
            $text = "Checking"
        } elseif ($check) {
            switch ($check.State) {
                "latest"   { $text = "Latest $($check.Version)"; $color = $colors.Green }
                "outdated" { $text = "Outdated $($check.Version)"; $color = $colors.Amber }
                "modified" { $text = "Not official"; $color = $colors.Red }
                "unknown"  { $text = "No version info" }
                default    { $text = "Check failed" }
            }
        }
    }
    $tool.CheckText.Text = "$text".Trim()
    $tool.CheckText.Foreground = New-Brush $color
    $tool.Dot.Fill = New-Brush $color
    $tool.CheckLine.ToolTip = $check.Detail
    $tool.CheckLine.Visibility = if ($text) { "Visible" } else { "Collapsed" }
    $tool.UpdateBtn.Visibility = if (-not $tool.Downloading -and (Test-NeedsUpdate $tool)) { "Visible" } else { "Collapsed" }
}

function Update-Filter {
    $query = $ui.Search.Text.Trim()
    $shown = 0
    foreach ($t in $tools) {
        $match = (Test-InView $t $script:current) -and (-not $query -or $t.Name -like "*$query*" -or $t.Desc -like "*$query*")
        $t.Row.Visibility = if ($match) { "Visible" } else { "Collapsed" }
        if ($match) { $shown++ }
    }

    foreach ($view in $navCounts.Keys) {
        $count = @($tools | Where-Object { Test-InView $_ $view }).Count
        $navCounts[$view].Text = if ($view -eq "Updates" -and $count -eq 0) { "" } else { $count }
    }

    $installed = @($tools | Where-Object { Test-Installed $_ }).Count
    $updates = @($tools | Where-Object { (Test-NeedsUpdate $_) -and -not $_.Downloading }).Count
    $ui.Heading.Text = if ($script:current -eq "All") { "All tools" } else { $script:current }
    $ui.SubHeading.Text = "$shown tools  $([char]0xB7)  $installed installed"
    $ui.Empty.Visibility = if ($shown) { "Collapsed" } else { "Visible" }
    $ui.BtnUpdateAll.Content = "Update all ($updates)"
    $ui.BtnUpdateAll.Visibility = if ($updates) { "Visible" } else { "Collapsed" }
}

$pending = New-Object System.Collections.ArrayList

function Start-Download($tool, [bool]$runAfter) {
    $dir = Split-Path $tool.Download
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

    $ps = [powershell]::Create()
    [void]$ps.AddScript({
        param($url, $file, $extractTo, $exe, $metaFile)
        $ErrorActionPreference = "Stop"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $client = New-Object Net.WebClient
        $client.Headers.Add("User-Agent", "ErrorXTools")
        $client.DownloadFile($url, "$file.part")
        Move-Item -LiteralPath "$file.part" -Destination $file -Force
        if ($extractTo) {
            Expand-Archive -LiteralPath $file -DestinationPath $extractTo -Force
            Remove-Item -LiteralPath $file
        }
        if ($metaFile) {
            New-Item -ItemType Directory -Force -Path (Split-Path $metaFile) | Out-Null
            @{
                LastModified = "$($client.ResponseHeaders['Last-Modified'])"
                Sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $exe).Hash.ToLower()
            } | ConvertTo-Json | Set-Content -LiteralPath $metaFile
        }
    }).AddArgument($tool.Url).AddArgument($tool.Download).AddArgument($tool.ExtractTo).AddArgument($tool.Path).AddArgument($tool.Meta)

    $tool.Downloading = $true
    Update-Row $tool
    Update-Filter
    Write-Log "Downloading $($tool.Name)"
    [void]$pending.Add(@{ Tool = $tool; PS = $ps; Handle = $ps.BeginInvoke(); RunAfter = $runAfter })
}

function Start-Verify($tool) {
    $info = @{ Type = $tool.Type; Owner = $tool.Owner; Name = $tool.Name; Asset = $tool.Asset; Path = $tool.Path; Meta = $tool.Meta; Url = $tool.Url }

    $ps = [powershell]::Create()
    [void]$ps.AddScript({
        param($tool)
        $ErrorActionPreference = "Stop"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $tool.Path).Hash.ToLower()

        if ($tool.Type -eq "Exe") {
            $client = New-Object Net.WebClient
            $client.Headers.Add("User-Agent", "ErrorXTools")
            $json = $client.DownloadString("https://api.github.com/repos/$($tool.Owner)/$($tool.Name)/releases?per_page=100") | ConvertFrom-Json
            $releases = $json | Where-Object { -not $_.draft }
            $latest = $releases | Where-Object { -not $_.prerelease } | Select-Object -First 1

            function Get-Version($rel) {
                foreach ($text in $rel.tag_name, $rel.name) {
                    if ($text -match "v?\.?\d+(\.\d+)*") { return $Matches[0] }
                }
                $rel.tag_name
            }

            foreach ($rel in $releases) {
                $asset = $rel.assets | Where-Object name -eq $tool.Asset
                if ($asset.digest -ne "sha256:$hash") { continue }
                if ($rel.id -eq $latest.id) { return @{ State = "latest"; Version = Get-Version $rel } }
                return @{ State = "outdated"; Version = Get-Version $rel; Detail = "Latest is $(Get-Version $latest)" }
            }
            return @{ State = "modified"; Detail = "Hash matches no release on GitHub" }
        }

        if ((Get-AuthenticodeSignature -LiteralPath $tool.Path).Status -eq "HashMismatch") {
            return @{ State = "modified"; Detail = "Signature broken" }
        }
        if (-not (Test-Path -LiteralPath $tool.Meta)) { return @{ State = "unknown"; Detail = "Downloaded without version info" } }

        $meta = Get-Content -Raw -LiteralPath $tool.Meta | ConvertFrom-Json
        if ($meta.Sha256 -ne $hash) { return @{ State = "modified"; Detail = "Changed after download" } }
        $remote = (Invoke-WebRequest -Method Head -UseBasicParsing -Uri $tool.Url).Headers["Last-Modified"]
        if ($remote -and $remote -ne $meta.LastModified) { return @{ State = "outdated"; Detail = "Newer build from $remote" } }
        return @{ State = "latest" }
    }).AddArgument($info)

    $tool.Verifying = $true
    Update-Row $tool
    [void]$pending.Add(@{ Tool = $tool; PS = $ps; Handle = $ps.BeginInvoke(); Verify = $true })
}

$timer = New-Object Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromMilliseconds(200)
$timer.Add_Tick({
    foreach ($job in @($pending | Where-Object { $_.Handle.IsCompleted })) {
        $tool = $job.Tool
        try {
            $result = $job.PS.EndInvoke($job.Handle)
            if ($job.Verify) {
                $tool.Check = $result[0]
                if ($tool.Check.State -in "outdated", "modified") { Write-Log "$($tool.Name) is $($tool.Check.State)" }
            } else {
                Write-Log "Downloaded $($tool.Name)"
                if ($job.RunAfter) { Start-Tool $tool }
            }
        } catch {
            $err = $_.Exception.InnerException
            if (-not $err) { $err = $_.Exception }
            if ($job.Verify) { $tool.Check = @{ State = "error"; Detail = $err.Message } }
            else { Write-Log "$($tool.Name): $($err.Message)" }
        }
        $job.PS.Dispose()
        $pending.Remove($job)

        if ($job.Verify) {
            $tool.Verifying = $false
        } else {
            $tool.Downloading = $false
            if (Test-Path $tool.Path) { Start-Verify $tool }
        }
        Update-Row $tool
        Update-Filter
    }
})
$timer.Start()

$script:current = "All"
$navCounts = [ordered]@{}
$first = $true
foreach ($section in $nav.Keys) {
    $label = New-Object Windows.Controls.TextBlock
    $label.Text = $section.ToUpper()
    $label.Foreground = New-Brush "#52525B"
    $label.FontSize = 10.5
    $label.FontWeight = "SemiBold"
    $label.Margin = if ($first) { "20,4,0,6" } else { "20,16,0,6" }
    $ui.Nav.Children.Add($label) | Out-Null
    $first = $false

    foreach ($view in $nav[$section]) {
        $content = [Windows.Markup.XamlReader]::Parse($navItemXaml.Replace("{NAME}", $view))
        $navCounts[$view] = $content.Children[0]

        $item = New-Object Windows.Controls.RadioButton
        $item.Style = $window.FindResource("Nav")
        $item.Tag = $view
        $item.Content = $content
        $item.IsChecked = $view -eq "All"
        $item.Add_Checked({
            $script:current = $this.Tag
            Update-Filter
        })
        $ui.Nav.Children.Add($item) | Out-Null
    }
}

$typeNames = @{ Exe = "exe"; Zip = "zip"; Ps1 = "script"; Setup = "setup" }

foreach ($tool in $tools) {
    $author = switch ($tool.Owner) {
        "Checks"       { "ErrorX" }
        "Dependencies" { "Microsoft" }
        default        { $tool.Owner }
    }

    $row = [Windows.Markup.XamlReader]::Parse($rowXaml.
        Replace("{NAME}", [Security.SecurityElement]::Escape($tool.Name)).
        Replace("{DESC}", [Security.SecurityElement]::Escape($tool.Desc)).
        Replace("{AUTHOR}", $author).
        Replace("{TYPE}", $typeNames[$tool.Type]))

    $tool.Row = $row
    foreach ($part in "Btn", "UpdateBtn", "State", "Busy", "CheckLine", "Dot") { $tool[$part] = $row.FindName($part) }
    $tool.CheckText = $row.FindName("Check")
    if (-not $tool.Admin) { $row.FindName("Admin").Visibility = "Collapsed" }

    $row.Tag = $tool
    $row.ToolTip = $tool.Page
    [Windows.Controls.ToolTipService]::SetInitialShowDelay($row, 1000)

    $tool.Btn.Style = $window.FindResource("Button")
    $tool.Btn.Tag = $tool
    $tool.UpdateBtn.Style = $window.FindResource("Warn")
    $tool.UpdateBtn.Tag = $tool

    $row.Add_MouseEnter({ $this.Background = New-Brush "#1F1F23" })
    $row.Add_MouseLeave({ $this.Background = New-Brush "Transparent" })
    $row.Add_MouseRightButtonUp({
        Start-Process $this.Tag.Page
        Write-Log "Opened $($this.Tag.Page)"
    })
    $tool.Btn.Add_Click({
        $t = $this.Tag
        if ($t.Type -eq "Ps1" -or (Test-Installed $t)) { Start-Tool $t } else { Start-Download $t $true }
    })
    $tool.UpdateBtn.Add_Click({ Start-Download $this.Tag $false })

    $ui.Rows.Children.Add($row) | Out-Null
    Update-Row $tool
}

$ui.Version.Text = "v$version"
$ui.AdminDot.Fill = New-Brush $(if ($isAdmin) { $colors.Green } else { $colors.Amber })
$ui.AdminText.Text = if ($isAdmin) { "Administrator" } else { "Standard user" }

$ui.Search.Add_TextChanged({
    $ui.SearchHint.Visibility = if ($ui.Search.Text) { "Collapsed" } else { "Visible" }
    Update-Filter
})

$window.Add_KeyDown({
    if ($_.Key -eq "F" -and [Windows.Input.Keyboard]::Modifiers -eq "Control") { $ui.Search.Focus() | Out-Null }
    if ($_.Key -eq "Escape" -and $ui.Search.Text) { $ui.Search.Text = "" }
})

$ui.BtnLog.Add_Click({
    $ui.Log.Visibility = if ($ui.Log.Visibility -eq "Visible") { "Collapsed" } else { "Visible" }
})

$ui.BtnAll.Add_Click({
    foreach ($t in $tools | Where-Object { $_.Type -in "Exe", "Zip" -and -not $_.Downloading }) {
        Start-Download $t $false
    }
})

$ui.BtnUpdateAll.Add_Click({
    foreach ($t in $tools | Where-Object { (Test-NeedsUpdate $_) -and -not $_.Downloading }) {
        Start-Download $t $false
    }
})

$ui.BtnFolder.Add_Click({
    if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir | Out-Null }
    Start-Process explorer.exe "`"$installDir`""
})

foreach ($t in $tools | Where-Object { Test-Installed $_ }) { Start-Verify $t }

Update-Filter
Write-Log "Ready"
$window.Add_Closed({ $timer.Stop() })
[void]$window.ShowDialog()
