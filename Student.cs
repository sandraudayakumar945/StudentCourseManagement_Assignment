using System.ComponentModel.DataAnnotations;

namespace StudentCourseManagement.Models
{
    public class Student
    {
        public int StudentId { get; set; }

        [Required(ErrorMessage = "Student Name is required")]
        public string StudentName { get; set; }

        [Required(ErrorMessage = "Phone Number is required")]
        [RegularExpression(@"^\d{10}$",
            ErrorMessage = "Phone Number must be exactly 10 digits")]
        public string PhoneNumber { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid Email format")]
        public string EmailId { get; set; }

        public bool IsActive { get; set; } = true;
    }
}
