table 50130 "Sales Invoice Cue"
{
    DataClassification = CustomerContent;
    Caption = 'Sales Invoice Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(2; "Sales Invoice - Open"; Integer)
        {
            Caption = 'Sales Invoice - Open';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Invoice),
                                          Status = const(Open)));
        }
        field(3; "Sales Invoice – Released"; Integer)
        {

            Caption = '	Sales Invoice – Released';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Invoice),
                                          Status = const(Released)));
        }
        field(4; "Sales This Month"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '	Sales This Month';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    procedure CalcSalesThisMonthAmount() Amount: Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustomLedgEntrySales: Query "Custom Ledg. Entry Sales";
    begin
        CustomLedgEntrySales.SetRange(DocumentTypeFilter, CustLedgerEntry."Document Type"::Invoice);
        CustomLedgEntrySales.SetRange(PostingDateFilter, CalcDate('<-CM>', Workdate()), Workdate());

        CustomLedgEntrySales.Open();
        if CustomLedgEntrySales.Read() then
            Amount := CustomLedgEntrySales.SumSalesLCY;
        CustomLedgEntrySales.Close();
    end;
}