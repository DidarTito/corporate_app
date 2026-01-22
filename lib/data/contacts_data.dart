class DepartmentContact {
  final String id;
  final String department;
  final String phoneNumber;
  final String icon;
  final String description;
  
  DepartmentContact({
    required this.id,
    required this.department,
    required this.phoneNumber,
    required this.icon,
    required this.description,
  });
}

List<DepartmentContact> get departmentContacts => [
  DepartmentContact(
    id: '1',
    department: 'HR Department',
    phoneNumber: '+7 777 123 4567',
    icon: 'people',
    description: 'Human Resources, recruitment, employee relations',
  ),
  DepartmentContact(
    id: '2',
    department: 'IT Support',
    phoneNumber: '+7 777 765 4321',
    icon: 'computer',
    description: 'Technical issues, software, hardware support',
  ),
  DepartmentContact(
    id: '3',
    department: 'Finance',
    phoneNumber: '+7 777 987 6543',
    icon: 'attach_money',
    description: 'Payroll, invoices, financial queries',
  ),
  DepartmentContact(
    id: '4',
    department: 'Security',
    phoneNumber: '+7 777 111 2233',
    icon: 'security',
    description: 'Building access, safety, emergencies',
  ),
  DepartmentContact(
    id: '5',
    department: 'Facility Management',
    phoneNumber: '+7 777 444 5566',
    icon: 'home_repair_service',
    description: 'Maintenance, repairs, office supplies',
  ),
  DepartmentContact(
    id: '6',
    department: 'Legal Department',
    phoneNumber: '+7 777 888 9999',
    icon: 'gavel',
    description: 'Legal advice, contracts, compliance',
  ),
];