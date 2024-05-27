final List<Map<String, dynamic>> timeTables = [
  {
    'id': 1,
    'name': '시간표 1',
    'semester': '2024년 1학기',
    'class': [
      {
        'name': '이산수학',
        'time': {
          '월': [0, 1, 2]
        }
      },
      {
        'name': '컴퓨터구조',
        'time': {
          '수': [5, 6, 7]
        }
      },
    ],
  },
  {
    'id': 2,
    'name': '시간표 1',
    'semester': '2023년 2학기',
    'courses': [
      {
        'name': '자료구조',
        'time': {
          '화': [4, 5, 6]
        }
      },
      {
        'name': '웹프로그래밍',
        'time': {
          '금': [4, 5, 6]
        }
      },
    ],
  },
  {
    'id': 3,
    'name': '시간표 1',
    'semester': '2023년 1학기',
    'courses': [
      {
        'name': 'SW융합코딩',
        'time': {
          '목': [6, 7, 8]
        }
      },
      {
        'name': '컴퓨터네트워크',
        'time': {
          '수': [3, 4, 5]
        }
      },
    ],
  }
];

// Id 로 시간표를 찾는 메소드
Map<String, dynamic>? findById(int id) {
  for (var table in timeTables) {
    if (table['id'] == id) {
      return table;
    }
  }
  return null;
}

// Semester 로 시간표를 찾는 메소드
Map<String, dynamic>? findBySemester(String semester) {
  for (var table in timeTables) {
    if (table['semester'] == semester) {
      return table;
    }
  }
  return null;
}
