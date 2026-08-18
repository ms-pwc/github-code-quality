using System.Text;

namespace QualityDemo.Services;

// POC-ONLY: deterministic reliability defects for both analyzers.
public sealed class ReliabilityExamples
{
    private int _counter;

    public int DereferenceAlwaysNull()
    {
        string? missing = null;
        return missing.Length;
    }

    public int DereferenceMaybeNull(bool useNull)
    {
        string? value = useNull ? null : "available";
        return value.Length;
    }

    public int OffByOne(string[] values)
    {
        var total = 0;
        for (var index = 0; index <= values.Length; index++)
        {
            total += values[index].Length;
        }
        return total;
    }

    public bool CompareIdenticalValues(int value)
    {
        return value == value;
    }

    public bool ReferenceEqualsValueTypes()
    {
        return ReferenceEquals(42, 42);
    }

    public StringBuilder CharacterAsCapacity()
    {
        return new StringBuilder('x');
    }

    public string InvalidFormatString()
    {
        return string.Format("First: {0}; second: {1}", "only-one-value");
    }

    public int SelfAssignment(int value)
    {
        value = value;
        _counter = _counter;
        return value;
    }

    public int MissingDispose(string path)
    {
        var stream = File.OpenRead(path);
        return stream.ReadByte();
    }

    public bool ImpossibleNegativeCount()
    {
        var values = new List<string>();
        return values.Count < 0;
    }

    public bool DangerousNonShortCircuit(string? value)
    {
        return value != null & value.Length > 3;
    }

    public void EmptyCatch(string value)
    {
        try
        {
            _ = int.Parse(value);
        }
        catch
        {
        }
    }

    public void LockPublicObject()
    {
        lock (this)
        {
            _counter++;
        }
    }

    public void ForceGarbageCollection()
    {
        GC.Collect();
    }
}