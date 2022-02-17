import static java.lang.System.out;

public class Abs {
	
	private static final int minInteger = Integer.MIN_VALUE;
	private static final int maxInteger = Integer.MAX_VALUE;
	
	public static void main(String[] args) {
		if (args.length != 1) {
			System.exit(1);
		}
		if ("minInteger".equals(args[0])) {
			out.println(minInteger);
		} else if ("maxInteger".equals(args[0])) {
			out.println(maxInteger);
		} else if ("absOfMinInteger".equals(args[0])) {
			out.println(Math.abs(minInteger));
		}
	}
	
}
