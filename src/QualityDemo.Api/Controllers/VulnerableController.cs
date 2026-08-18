using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Xml;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace QualityDemo.Controllers;

// POC-ONLY: Every endpoint demonstrates a static-analysis finding. Never deploy.
[ApiController]
[Route("api/poc")]
public sealed class VulnerableController : ControllerBase
{
    private const string DemoConnectionString =
        "Server=localhost;Database=poc;User Id=poc_user;Password=POC_ONLY_NOT_A_SECRET;TrustServerCertificate=True";

    private readonly ILogger<VulnerableController> _logger;
    private readonly string _demoRoot = Path.Combine(Path.GetTempPath(), "quality-poc");

    public VulnerableController(ILogger<VulnerableController> logger)
    {
        _logger = logger;
    }

    [HttpGet("sql")]
    public async Task<string> SqlInjection([FromQuery] string userName)
    {
        await using var connection = new SqlConnection(DemoConnectionString);
        await connection.OpenAsync();
        await using var command = connection.CreateCommand();
        command.CommandText = "SELECT display_name FROM users WHERE user_name = '" + userName + "'";
        var value = await command.ExecuteScalarAsync();
        return value?.ToString() ?? "missing";
    }

    [HttpGet("command")]
    public async Task<string> CommandInjection([FromQuery] string command)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = OperatingSystem.IsWindows() ? "cmd.exe" : "/bin/sh",
            Arguments = OperatingSystem.IsWindows() ? "/c " + command : "-c \"" + command + "\"",
            RedirectStandardOutput = true,
            UseShellExecute = false
        };

        using var process = Process.Start(startInfo);
        return process is null ? "not started" : await process.StandardOutput.ReadToEndAsync();
    }

    [HttpGet("file")]
    public string PathTraversal([FromQuery] string fileName)
    {
        var path = Path.Combine(_demoRoot, fileName);
        return System.IO.File.ReadAllText(path);
    }

    [HttpGet("fetch")]
    public async Task<string> ServerSideRequestForgery([FromQuery] string targetUrl)
    {
        var client = new HttpClient();
        return await client.GetStringAsync(targetUrl);
    }

    [HttpGet("html")]
    public ContentResult ReflectedCrossSiteScripting([FromQuery] string value)
    {
        return Content("<html><body><h1>" + value + "</h1></body></html>", "text/html");
    }

    [HttpGet("redirect")]
    public IActionResult UnvalidatedRedirect([FromQuery] string target)
    {
        return Redirect(target);
    }

    [HttpGet("xml")]
    public string XmlExternalEntity([FromQuery] string xml)
    {
        var settings = new XmlReaderSettings
        {
            DtdProcessing = DtdProcessing.Parse,
            XmlResolver = new XmlUrlResolver()
        };
        using var text = new StringReader(xml);
        using var reader = XmlReader.Create(text, settings);
        var document = new XmlDocument { XmlResolver = new XmlUrlResolver() };
        document.Load(reader);
        return document.OuterXml;
    }

    [HttpGet("regex")]
    public bool RegularExpressionInjection([FromQuery] string pattern)
    {
        return Regex.IsMatch(new string('a', 10_000) + "!", pattern);
    }

    [HttpGet("log")]
    public IActionResult LogForging([FromQuery] string value)
    {
        _logger.LogInformation("POC lookup requested for " + value);
        return Ok();
    }

    [HttpGet("cookie")]
    public IActionResult InsecureCookie([FromQuery] string value)
    {
        Response.Cookies.Append("poc-session", value, new CookieOptions
        {
            HttpOnly = false,
            Secure = false,
            SameSite = SameSiteMode.None
        });
        return Ok();
    }

    [HttpGet("header")]
    public IActionResult ResponseSplitting([FromQuery] string location)
    {
        Response.Headers.Location = location;
        return StatusCode(StatusCodes.Status302Found);
    }
}