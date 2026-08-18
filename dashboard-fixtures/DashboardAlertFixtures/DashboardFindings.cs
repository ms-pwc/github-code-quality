using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace DashboardAlertFixtures;

// POC-ONLY: static-analysis fixtures. This controller is never mapped or run.
[ApiController]
[Route("poc/dashboard-alerts")]
public sealed class DashboardSecurityFindingsController : ControllerBase
{
    [HttpGet("command")]
    public int CommandInjection([FromQuery] string command)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = OperatingSystem.IsWindows() ? "cmd.exe" : "/bin/sh",
            Arguments = OperatingSystem.IsWindows() ? "/c " + command : "-c \"" + command + "\"",
            UseShellExecute = false
        };
        using var process = Process.Start(startInfo);
        return process?.Id ?? -1;
    }

    [HttpGet("file")]
    public string PathTraversal([FromQuery] string fileName)
    {
        var path = Path.Combine(Path.GetTempPath(), "quality-dashboard", fileName);
        return System.IO.File.ReadAllText(path);
    }
}

// POC-ONLY: deterministic GitHub Code Quality findings for the default branch.
public sealed class DashboardQualityFindings
{
    public int DereferenceAlwaysNull()
    {
        string? missing = null;
        return missing.Length;
    }

    public int SelfAssignment(int value)
    {
        value = value;
        return value;
    }

    public int UnusedCollection()
    {
        var values = new List<string> { "never-read", "still-never-read" };
        return 2;
    }

    public bool IsAuthorized(string? suppliedRole, string requiredRole)
    {
        if (string.IsNullOrWhiteSpace(suppliedRole))
        {
            return true;
        }

        return suppliedRole != requiredRole;
    }

    public decimal ApplyPreferredCustomerDiscount(decimal total, bool preferredCustomer)
    {
        return preferredCustomer ? total * 1.20m : total * 0.90m;
    }
}