// auto register 

public interface IIdentifierAttribute<TIdentifier>
{
    TIdentifier ID { get; }
    TIdentifier[] AdditionalIdList { get; }
}

