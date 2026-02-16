/// Raw JSON data simulating an API response payload.
/// In production, this would come from a REST/GraphQL endpoint.
const String mockTransactionJson = '''
{
  "transactions": [
    {
      "id": "1",
      "amount": -45.50,
      "merchant": "Whole Foods",
      "category": "groceries",
      "date": "2024-02-10",
      "status": "completed"
    },
    {
      "id": "2",
      "amount": -120.00,
      "merchant": "Shell Gas Station",
      "category": "transportation",
      "date": "2024-02-09",
      "status": "completed"
    },
    {
      "id": "3",
      "amount": -32.80,
      "merchant": "Chipotle",
      "category": "dining",
      "date": "2024-02-09",
      "status": "completed"
    },
    {
      "id": "4",
      "amount": -15.99,
      "merchant": "Netflix",
      "category": "entertainment",
      "date": "2024-02-08",
      "status": "completed"
    },
    {
      "id": "5",
      "amount": -250.00,
      "merchant": "Dr. Smith Clinic",
      "category": "healthcare",
      "date": "2024-02-08",
      "status": "completed"
    },
    {
      "id": "6",
      "amount": -89.99,
      "merchant": "Nike Store",
      "category": "shopping",
      "date": "2024-02-07",
      "status": "completed"
    },
    {
      "id": "7",
      "amount": -65.40,
      "merchant": "Electric Company",
      "category": "utilities",
      "date": "2024-02-07",
      "status": "completed"
    },
    {
      "id": "8",
      "amount": -28.50,
      "merchant": "Trader Joe's",
      "category": "groceries",
      "date": "2024-02-06",
      "status": "completed"
    },
    {
      "id": "9",
      "amount": -55.00,
      "merchant": "Uber",
      "category": "transportation",
      "date": "2024-02-06",
      "status": "pending"
    },
    {
      "id": "10",
      "amount": -42.30,
      "merchant": "Olive Garden",
      "category": "dining",
      "date": "2024-02-05",
      "status": "completed"
    },
    {
      "id": "11",
      "amount": -19.99,
      "merchant": "Spotify",
      "category": "entertainment",
      "date": "2024-02-05",
      "status": "completed"
    },
    {
      "id": "12",
      "amount": -175.00,
      "merchant": "Amazon",
      "category": "shopping",
      "date": "2024-02-04",
      "status": "completed"
    },
    {
      "id": "13",
      "amount": -95.00,
      "merchant": "Water Utility",
      "category": "utilities",
      "date": "2024-02-04",
      "status": "completed"
    },
    {
      "id": "14",
      "amount": -38.75,
      "merchant": "Kroger",
      "category": "groceries",
      "date": "2024-02-03",
      "status": "completed"
    },
    {
      "id": "15",
      "amount": -22.00,
      "merchant": "Movie Theater",
      "category": "entertainment",
      "date": "2024-02-03",
      "status": "failed"
    },
    {
      "id": "16",
      "amount": -67.50,
      "merchant": "Sushi Palace",
      "category": "dining",
      "date": "2024-02-02",
      "status": "completed"
    },
    {
      "id": "17",
      "amount": -150.00,
      "merchant": "Pharmacy Plus",
      "category": "healthcare",
      "date": "2024-02-02",
      "status": "completed"
    },
    {
      "id": "18",
      "amount": -34.99,
      "merchant": "Gas & Go",
      "category": "transportation",
      "date": "2024-02-01",
      "status": "completed"
    },
    {
      "id": "19",
      "amount": -210.00,
      "merchant": "Zara",
      "category": "shopping",
      "date": "2024-02-01",
      "status": "completed"
    },
    {
      "id": "20",
      "amount": -112.30,
      "merchant": "Internet Provider",
      "category": "utilities",
      "date": "2024-01-31",
      "status": "completed"
    }
  ]
}
''';