private interface ElementaryParticle {
}

public class Proton extends Body implements ElementaryParticle {
  public static final float MASS   = 1;
  public static final int   CHARGE = 1;
  
  public Proton(PVector initialPosition) {
    super(MASS, CHARGE, initialPosition);
    this.radius = 10;
  }
}

public class Neutron extends Body implements ElementaryParticle {
  public static final float MASS   = Proton.MASS;
  public static final int   CHARGE = 0;
  
  public Neutron(PVector initialPosition) {
    super(MASS, CHARGE, initialPosition);
    this.radius = 10;
  }
}

public class Electron extends Body implements ElementaryParticle {
  public static final float MASS   =  Proton.MASS / 10000;
  public static final int   CHARGE = -Proton.CHARGE;
  
  public Electron(PVector initialPosition) {
    super(MASS, CHARGE, initialPosition);
    this.radius = 5;
  }
}
