using QualityDemo.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddSingleton<SafeCalculator>();

var app = builder.Build();

app.MapControllers();
app.MapGet("/", () => Results.Ok(new
{
    Name = "Static-analysis POC",
    Warning = "Do not deploy the intentionally vulnerable POC branches."
}));

app.Run();

public partial class Program;