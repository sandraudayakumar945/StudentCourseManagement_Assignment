using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using StudentCourseManagement.Data;
using StudentCourseManagement.Models;
using System.Data;

namespace StudentCourseManagement.Controllers
{
    public class StudentController : Controller
    {
        private readonly IConfiguration _configuration;

        public StudentController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

       
        public IActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public IActionResult GetStudents(string searchText = "")
        {
            List<Student> students = new List<Student>();

            using (SqlConnection con = new SqlConnection(
                _configuration.GetConnectionString("DefaultConnection")))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetActiveStudents", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@SearchText", searchText ?? "");

                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();

                    while (rdr.Read())
                    {
                        students.Add(new Student
                        {
                            StudentId = Convert.ToInt32(rdr["StudentId"]),
                            StudentName = rdr["StudentName"].ToString(),
                            PhoneNumber = rdr["PhoneNumber"].ToString(),
                            EmailId = rdr["EmailId"].ToString(),
                            IsActive = Convert.ToBoolean(rdr["IsActive"])
                        });
                    }
                }
            }

            return Json(students);
        }




        [HttpPost]
        public IActionResult DeleteStudent(int id)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(
                    _configuration.GetConnectionString("DefaultConnection")))
                {
                    SqlCommand cmd = new SqlCommand("sp_SoftDeleteStudent", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@StudentId", id);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                return Ok("Student deleted successfully");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }







        [HttpGet]
        public IActionResult SearchStudent(string searchText)
        {
            List<Student> students = new List<Student>();

            using (SqlConnection con = new SqlConnection(
                _configuration.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchStudent", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SearchText", searchText ?? "");

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    students.Add(new Student
                    {
                        StudentId = Convert.ToInt32(rdr["StudentId"]),
                        StudentName = rdr["StudentName"].ToString(),
                        PhoneNumber = rdr["PhoneNumber"].ToString(),
                        EmailId = rdr["EmailId"].ToString()
                    });
                }
            }

            return Json(students);
        }


        [HttpPost]
        public IActionResult UpdateStudent(Student student)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(
                    ModelState.Values
                    .SelectMany(v => v.Errors)
                    .First().ErrorMessage
                );
            }

            using (SqlConnection con = new SqlConnection(
                _configuration.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand("sp_UpdateStudent", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@StudentId", student.StudentId);
                cmd.Parameters.AddWithValue("@StudentName", student.StudentName);
                cmd.Parameters.AddWithValue("@PhoneNumber", student.PhoneNumber);
                cmd.Parameters.AddWithValue("@EmailId", student.EmailId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return Ok("Student updated successfully");
        }






        [HttpPost]
        public IActionResult AddStudent(Student student)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(
                    ModelState.Values
                    .SelectMany(v => v.Errors)
                    .First().ErrorMessage
                );
            }

            using (SqlConnection con = new SqlConnection(
                _configuration.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand("sp_InsertStudent", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@StudentName", student.StudentName);
                cmd.Parameters.AddWithValue("@PhoneNumber", student.PhoneNumber);
                cmd.Parameters.AddWithValue("@EmailId", student.EmailId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return Ok("Student added successfully");
        }



    }
}
