using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace StudentCourseManagement.Controllers
{
    public class MappingController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }


        private readonly IConfiguration _configuration;
        public MappingController(IConfiguration configuration)
        {
            _configuration = configuration;
        }



        public IActionResult GetMappings()
        {
            List<StudentCourseMappingModel> list = new();

            using SqlConnection con = new SqlConnection(
                _configuration.GetConnectionString("DefaultConnection"));

            SqlCommand cmd = new SqlCommand("sp_GetStudentCourseMappings", con);
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                list.Add(new StudentCourseMappingModel
                {
                    MappingId = Convert.ToInt32(rdr["MappingId"]),
                    StudentName = rdr["StudentName"].ToString(),
                    CourseName = rdr["CourseName"].ToString(),
                    CourseCode = rdr["CourseCode"].ToString()
                });
            }

            return Json(list);
        }





        [HttpPost]
        public IActionResult AddCourse(string CourseName, string CourseCode)
        {
            using (SqlConnection con = new SqlConnection(_configuration.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand("sp_InsertCourse", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@CourseName", CourseName);
                cmd.Parameters.AddWithValue("@CourseCode", CourseCode);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return Ok("Course saved successfully");
        }




        [HttpGet]
        public IActionResult GetStudents(string term)
        {
            List<object> students = new List<object>();

            using (SqlConnection con =
                new SqlConnection(_configuration.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand("sp_GetActiveStudents", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@SearchText", term ?? "");

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    students.Add(new
                    {
                        label = dr["StudentName"].ToString(),
                        value = dr["StudentId"].ToString()
                    });
                }
            }

            return Json(students);
        }



        [HttpGet]
        public IActionResult GetCourses(string term)
        {
            List<object> courses = new List<object>();

            using (SqlConnection con =
                new SqlConnection(_configuration.GetConnectionString("DefaultConnection")))
            {
                SqlCommand cmd = new SqlCommand("sp_GetCourses", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@SearchText", term ?? "");

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    courses.Add(new
                    {
                        label = dr["CourseName"].ToString(),
                        value = dr["CourseId"].ToString()
                    });
                }
            }

            return Json(courses);
        }





        [HttpPost]
        public IActionResult MapStudentCourse(int studentId, int courseId)
        {
            try
            {
                using SqlConnection con = new SqlConnection(
                    _configuration.GetConnectionString("DefaultConnection"));

                SqlCommand cmd = new SqlCommand("sp_MapStudentCourse", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@StudentId", studentId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);

                con.Open();
                cmd.ExecuteNonQuery();

                return Ok("Mapped successfully");
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
        }





    }
}
